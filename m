Return-Path: <kvm+bounces-14897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C8E268A76CE
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 23:38:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC5EB1C22BD8
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 21:38:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1272D6E61D;
	Tue, 16 Apr 2024 21:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CsaJP5J4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lPk7feFu"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EA25D8F6;
	Tue, 16 Apr 2024 21:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713302975; cv=fail; b=u8fgaMtNdCQpiWP24ofJAuolcPIcRgG8hgVolMIXoLi2X7aAA4KztGF6rXw7Ro5MSm7xbS+bfgnd3cy+Ev3FmmEk9qcOUqbFzpcp3Q1fLZ81zk+u2LReEp3Gpm2wQJwWQ1EmrF8Y52Cx5E0QzLIf+nN8Otk9uigG9QGxksajAWE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713302975; c=relaxed/simple;
	bh=t9tFblHF+qt/gfc0F+/0V9bCYhfG8TNnTyx7AlmYTQY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RlF65WsufxWGwtzsVbzFZzTGctzVpHAKR3PG0hnW3AFt5Z9MMfE4DnDvBXfNgffZnJAWViPCVFpLJt1kKUYSFyCdiovMZ7qaEy4TeewQJJG4y3b8RBf7p0IarMOU/99osq4hZFcXgGcUf/6V5mZZ5MrnPoh14gDUMUbC9+VHezs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CsaJP5J4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lPk7feFu; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43GJjx1H023466;
	Tue, 16 Apr 2024 21:29:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=6Lx1O9uzfZoxpsE7s/MHj9dlWkW6+ocfFVTlbSkUATM=;
 b=CsaJP5J4ZmZ04uPJV4PmVuJSMpoafpYH9ltaBqI4CVPOpu3L0TuUq3CmtMaQ3EDQcj+l
 zZvHyl6WNWtopgoQuupuicc1W/jRJ/d2R2rlq1Jpw30Kr6rdRTLgLSQmPRYlQIQV7LTC
 pJX0/wOUubfmTauZOrUq4Q1lSzrFPKCqgN8PFD8QX/xJoqqLEu+9J2BpTza5qPzkl8/o
 lapYMKbf8Rb0WvNdQvNTFb+P49fIjT0GT3PjhgsaZXA8PLe1y2iesfZmzPWT+E0Y7hju
 SsB9sssVJ1Sd90kfintY+xfU+V2hB+k0kCOJBgV4p5aO7YUjdSxWqX57lMxzdMstktBW PQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xfhxbpa2q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Apr 2024 21:29:27 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43GLNQea028851;
	Tue, 16 Apr 2024 21:29:26 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xfgg7us5n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Apr 2024 21:29:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NKiSjThLBPT93wasPsmmKty6XZp1VQAQsbqsbrGrHrcPGO1Lo4KL0qNGsiZEFvBBnPtcFZEO8IzEJU2Eg3MwIWLpRoLFK0IqRrcDWM5149XYv4THY+tzn9tBEoPLa064VBP8l/H5N+8OU1J+cxdqnbIwUtHRU1uOvBqsYEP/JFazmJXMfOW2AxDA3Xb8H6vcn5fXQAArmcDM1zMIdI01j+nAqRnkhNF0KRBbkG/9/rlhu/FlSizsWVKrXAfq1yKWHNygKPiC3BxdUyXktlL7iwSezFzIeLiYrLWpKkQoKLo3enK6r4OUkcYI3xPyPQ0XYBWN/LvIHhVBJ7qRFzGMHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Lx1O9uzfZoxpsE7s/MHj9dlWkW6+ocfFVTlbSkUATM=;
 b=G6QGPjITT1MnRBEOlsaK38zwkMsmr38gfh18C4uig1kOmjVMNSx5uq5gXCgbwNCMtShMu30fc3TWZXO3WFtdz5s3co37iuZDoGzm2+60GZ4P5mk6YZ8wWqQFG/T1Q1rSCKhkwsUs2ZpbEch9XelgL7v7kc6HkzsPl+lGFX/dvKLLlMlp2UWsljP8W40J3vEy6ruOzHIrzK1WmaEhsbyTVRRevoErOMb0kT7h1GGA52SXhTmUYByHaP8gxDDepKM6p+q5hZLrl07Hik3Qmlf3mhb2IQm+2WemPCphtnR1h3qsWwbAlHG0CnUPXuOwLFga4i1tKKlYGBWAbDhYWpL98Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Lx1O9uzfZoxpsE7s/MHj9dlWkW6+ocfFVTlbSkUATM=;
 b=lPk7feFuH1cppFYOB3NzViKZ1opP9oeqciwWkkESSfzYJgJU+hBxA4RD+0b1LgaZW0rbyUvnyHljcqt99cjJTuoNhA7oVb99yRPGNA2sQGXFkx2uEzza8SlTaKrzJ2urZuIEy2fRizD7bPhXhF+DJVo3gZ20g1lrfLqmLFuJeG4=
Received: from DS7PR10MB5280.namprd10.prod.outlook.com (2603:10b6:5:3a7::5) by
 CO1PR10MB4484.namprd10.prod.outlook.com (2603:10b6:303:90::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7452.50; Tue, 16 Apr 2024 21:29:24 +0000
Received: from DS7PR10MB5280.namprd10.prod.outlook.com
 ([fe80::c7cc:f6b7:386e:fd5d]) by DS7PR10MB5280.namprd10.prod.outlook.com
 ([fe80::c7cc:f6b7:386e:fd5d%6]) with mapi id 15.20.7452.049; Tue, 16 Apr 2024
 21:29:24 +0000
Message-ID: <4cdf71ca-c4e4-49a5-a64d-d0549ad2cf7b@oracle.com>
Date: Tue, 16 Apr 2024 17:29:21 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 0/3] Export APICv-related state via binary stats interface
To: Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        mark.kanda@oracle.com, suravee.suthikulpanit@amd.com,
        mlevitsk@redhat.com
References: <20240215160136.1256084-1-alejandro.j.jimenez@oracle.com>
 <Zh6-h0lBCpYBahw7@google.com>
 <CABgObfZ4kqaXLaOAOj4aGB5GAe9GxOmJmOP+7kdke6OqA35HzA@mail.gmail.com>
Content-Language: en-US
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
In-Reply-To: <CABgObfZ4kqaXLaOAOj4aGB5GAe9GxOmJmOP+7kdke6OqA35HzA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR16CA0059.namprd16.prod.outlook.com
 (2603:10b6:208:234::28) To DS7PR10MB5280.namprd10.prod.outlook.com
 (2603:10b6:5:3a7::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5280:EE_|CO1PR10MB4484:EE_
X-MS-Office365-Filtering-Correlation-Id: 9000b1b2-4d89-44fb-e426-08dc5e5c4928
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	nDrZgZiOjmiEleyh6WphrRSmbfNqtHVHBXV7kNAdPMF73ErGa4idf3IH//9zF9mbVe4cZDscqXs4sgbWowHXFNggNkOUhh8qPCOQo0cdQJhuPciuAaf4MwkQlbl9HDCq7kqobs6kaUvqqZS+kjAnKKv3e7tko4RJvz5Typhracr2D77vcWdk8bQxHGIvV7vVKQ3cFMSnd8uSBJEqlMLXxitN7H7bNvRKrGLyphROQiw6jWHFRvgGS4Y2/KmXB/eUN1SFImVC0avGtj1ppLwOkKzwP+ixwXQKqVb2Pc9etFhrZMigwdjEZHQ39khhV77mnpoCFHKWf/qQtaDQ18hqDXPSN2qVMm7cBdBWstd36f6dTmNiuVqb/KmVRpc91vpf8BwUQt2sCnm0Ka8eBH82azGvkIgxfr0/FkKlep89tzI7XfksroEPn+22kVaE2vvOKDc5KgrYvka91/4peG44T3/t8JC+iCZzHir7twDI4CzwJEdFp1Is7B1BCsgaALxhW+8neIBA9v3jHlrSPZxUyQ2QbI7cKrWeaj73pPFPNvcfB81vLzhjSbZ5ps+j1Z5zzqAyg6IRB80pyLkoZBwskVI4/yxXOHNmqKM2ZS2kgtqoyeOEVrCHo/iBM6IyLrjrf9VkIJ49hvirzAxZyH4Ik2u4dtGFlMbuiTueXw4emW0=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5280.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?K0h2Tk9OMThUV1c3MkxWdTFQU3hHSSsyek1UK2p6UXFzN013UUJvaVJDeUE3?=
 =?utf-8?B?aDVrbmZ6dG5td1oxQ0FvYzF6blk1L2lZTi9NVVlXbll3aU9KM3Y0dWdJYjhF?=
 =?utf-8?B?Z3ZsUmQ5QjI0N2JkSEIvWXFsV0xzbnNkZ1NJT1pncnNNdzlYZ3dEbnNlVEJl?=
 =?utf-8?B?RFRxRHk0bHEyeXlsZWhxNFVoVnlYZE1vZ2hZZGl4ZzhhdGNhTzVGY3B1NXEx?=
 =?utf-8?B?ZzRaS24wRUhJVUFtYzcrOHRaZlh4azMrZGZMM1NoQlNJdDd4U0wwMkNDNWtU?=
 =?utf-8?B?NFFyUUJLZ2gxOWRKOU1RY05TVkErRHZEczVFWHlqZnpCbEtyb0xOMU1BVk00?=
 =?utf-8?B?Mlk1MkNjaVhPbFoyUEhnbnJxSmkrTXRZS3hlVFFUK0JLZGJGbWFYT0d5Tkdm?=
 =?utf-8?B?a2RrKzE3SXRkYnVPZ1c3bmxVNllMNWkvZmFPYmFMZnh3eVNzdXV5azFuS2dB?=
 =?utf-8?B?amRENUJNOGtNR1NvUW1oK3NJL1RFN01GaU5lQVkwODBjOUFmS3lleUZVNU1a?=
 =?utf-8?B?Z3FSWGtuSjgvdGVjelNsZzlQcXJ4SzNxNnJPYTZjRXJLd1ZpZTEySHc3QWF6?=
 =?utf-8?B?M0l2VklabDhnUnNWaDdWM2RVbURReVRJT25nTEtPNVBQZlY1MmhEdjh0c0VU?=
 =?utf-8?B?Q1JpRy94QmU5a08weFcrL2hUQlBRVnZuZ29rSnh4SldEQWJ1M2E5MjJwaGx1?=
 =?utf-8?B?aHBVZWhtaWc1VDlvalBEU21mT05HV1RpWW81UFQrKzB6UzZTV1FlT0hHdWx0?=
 =?utf-8?B?TitBRHMralFmeUxhYnVWdVRQVDlXZWR4dlJ4Qm1kQXFrM3pOdHBUb0hrc0VL?=
 =?utf-8?B?K2dvRUdyempQWlA4b2FHQ3A4UmR6M29WeW91VmNuaEptUklaOElLS0ZEV2gw?=
 =?utf-8?B?L01LOUYzVWV1UnhzZXVrU3dXSnNKQkR2ZWRpZE9QRjA3TWpUTWFIZkdxWEY0?=
 =?utf-8?B?Q25zSXN5MWZJU0pjR2FHRjhBcUN0eitMc0lub3d1ZzlBQUtEZkJIK1JhK3gr?=
 =?utf-8?B?RGlJY3Zva0FEbUJyM0htMW5IS29uN2RpcjBPSEw2dU5lTkFBVHo2RUluZERN?=
 =?utf-8?B?S2RtZ2ZDZzh3K1ZncGdaaFNhSk1EYTN2NVBnV0ptRVJ0bTU1WW5idTRxQ0VC?=
 =?utf-8?B?ZlUrMzM1b0Qvb2hDRno1bFR2WXJoTFpFa1VtNk8vRkh1dDkySHJpM1VFVDhK?=
 =?utf-8?B?VFAxL0ltUVUwU0w4b3M3T2JvNnJ2a3JrVWFCeXU4RWZHTzd2ZktNbURpREhK?=
 =?utf-8?B?UFFlL2VhRDlMM1pxeW9Wb1o1STQrSkIzTGVNaTRoaGdCVXZHQzdoa0xVWStk?=
 =?utf-8?B?TkM1UDRyN1JiTGlldTFMQUxJbjFjdDNtNThsN1NnZDJyVVZQYUMzWjBxVGJ5?=
 =?utf-8?B?bkY2b0JiT2dmL2E3ZlJXeldZbDVZcHgySDR1c203YUhLWThrMzBrQkFtWjZu?=
 =?utf-8?B?Zzk5Zm5jWEJZYVA2QlRPbmllUEpDUitRWUdmakJpbER2U3VmQjNKclZHREsr?=
 =?utf-8?B?RG1STVIyQkhqNzcrZlA3cFVZY0xpVHdod1NPTHR2b0ZZRko4STdXZFM2UXJp?=
 =?utf-8?B?YTVTQXM2eVpsNTJ5YVJqemwrNVNXRlNVakdMU0JnSlZZSGFHNXNuaERkME53?=
 =?utf-8?B?MFp6aEFzRGZPSlh6SExFNjAvTVpFc1pPdGw1NkJVbGx0WW1RSktkSGNIVUJK?=
 =?utf-8?B?M2lLa2dEdTA0Q21Yb2tONGJlQXNoM1pFbWhucys3Qitsa0UxaUlVdW8xY3Ba?=
 =?utf-8?B?ang1aXJvZU1rT1BtUWovYW1VTmc3WnY4d0JpVnhUZDZGNjh6SVc4R0Y5YjBE?=
 =?utf-8?B?MmFBNGFZblo0amxtb0VlUkFCVk9NWEprM2ZKOGNHcWhydGFmcUtOZmlUVlJP?=
 =?utf-8?B?VHIrZFB0cEpVRDl0N1dGMndRcVluekZaeW5xd3U1NXZoRVB4MExjL2c2bXY0?=
 =?utf-8?B?N0ZsMXY1MzYrdzE0SFlnMndoVnlhZEp0ZWxOMmxvbEZNL2FxczJya1lTTysx?=
 =?utf-8?B?U3ovOWtMeVUzQ0FDNnU5UHJQelFTMEVoVTk2Q1RzYzJQdFpuaDNmWUduTWxT?=
 =?utf-8?B?amdPWWNkb0w1SVJuRjFJaDl4QlRkNFJtVmVCOU9GVFA3Z282RE5GVjRMeEFq?=
 =?utf-8?B?NnJBQnZpZlFYckxadEl0OU5zemNKWFZLMTVGdTIvTHdTQnV0MEdZWnNHYXlJ?=
 =?utf-8?B?ZUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	BG3RkUeYnqd8HJdSKBFA1+6zSMaLT/u37VcCol2wSswVUtN7g6finHbSgcSxZ7UQyeMXsdt9xTuNgwxPRDvodtfxStbCyFerKYjCiH2+VI9wOq9U9a9LyGmOI2DeL5yPv+AtPfiW+AfhsgonJpZJX6XHeP1imIlcwUELF1KxwAwteUqjjqtuh/uLV8C8w/f9YmKFHfnqObT4RHSA0Y6LSp/xFuXvP7sIIZBVaDcnjEPlwvqMsvIZIP/OjI2MQruFNOUladG2PRmlnwGGZ3KE8dyUn7bqDpHfzXFSwkHDewrhaNyNFiORf7m3xUfZ6xXQ9whLKiOe5mwdMMX/GoLJiW3E3fzrnT1e1iJl2KK9QZDhbNtOvWXhBNC8l4D7Fe4Jj5pwrqq6EZXrhITgrM1NoewvldrR9+18o3RVEHD4bissLSEpIa84ioTEGPxsItKdIjeYeoKtQDQ+mtkiV01TaXbPX8pFlcDWkJuiOpWQ56DwO143FGyjVuuxYG/OMip4j9SUETS2GbVlChGQtsF4Vj3ahCfvJV5NJjT+o9LeywuzQ3USGXArCrRxPkaVMmTMtHWcktIG7eBwzk9VIU+lZMTQ0sTkTC75SJ3eQI5QZpo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9000b1b2-4d89-44fb-e426-08dc5e5c4928
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5280.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 21:29:23.9874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 64MpaGQMvY6p8OfRwmOw5QB8IciLJ8wPpfHr5i0sV2260NB7w2q5adp4Ecd1s0sAkBEp3ckQJecFD/b0GQGdCgrOwH6jivP4tNcNXKNlTgU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4484
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-16_18,2024-04-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404160138
X-Proofpoint-ORIG-GUID: u0FpoYFCb9uvB1ybkR4aq4e3BYrOBjED
X-Proofpoint-GUID: u0FpoYFCb9uvB1ybkR4aq4e3BYrOBjED



On 4/16/24 15:51, Paolo Bonzini wrote:
> On Tue, Apr 16, 2024 at 8:08 PM Sean Christopherson <seanjc@google.com> wrote:
>>
>> On Thu, Feb 15, 2024, Alejandro Jimenez wrote:
>>> The goal of this RFC is to agree on a mechanism for querying the state (and
>>> related stats) of APICv/AVIC. I clearly have an AVIC bias when approaching this
>>> topic since that is the side that I have mostly looked at, and has the greater
>>> number of possible inhibits, but I believe the argument applies for both
>>> vendor's technologies.
>>>
>>> Currently, a user or monitoring app trying to determine if APICv is actually
>>> being used needs implementation-specific knowlegde in order to look for specific
>>> types of #VMEXIT (i.e. AVIC_INCOMPLETE_IPI/AVIC_NOACCEL), checking GALog events
>>> by watching /proc/interrupts for AMD-Vi*-GA, etc. There are existing tracepoints
>>> (e.g. kvm_apicv_accept_irq, kvm_avic_ga_log) that make this task easier, but
>>> tracefs is not viable in some scenarios. Adding kvm debugfs entries has similar
>>> downsides. Suravee has previously proposed a new IOCTL interface[0] to expose
>>> this information, but there has not been any development in that direction.
>>> Sean has mentioned a preference for using BPF to extract info from the current
>>> tracepoints, which would require reworking existing structs to access some
>>> desired data, but as far as I know there isn't any work done on that approach
>>> yet.
>>>
>>> Recently Joao mentioned another alternative: the binary stats framework that is
>>> already supported by kernel[1] and QEMU[2].
>>
>> The hiccup with stats are that they are ABI, e.g. we can't (easily) ditch stats
>> once they're added, and KVM needs to maintain the exact behavior.
> 
> Stats are not ABI---why would they be? They have an established
> meaning and it's not a good idea to change it, but it's not an
> absolute no-no(*); and removing them is not a problem at all.
> 
> For example, if stats were ABI, there would be no need for the
> introspection mechanism, you could just use a struct like ethtool
> stats (which *are* ABO).
> 
> Not everything makes a good stat but, if in doubt and it's cheap
> enough to collect it, go ahead and add it. Cheap collection is the
> important point, because tracepoints in a hot path can be so expensive
> as to slow down the guest substantially, at least in microbenchmarks.
> 
> In this case I'm not sure _all_ inhibits makes sense and I certainly
> wouldn't want a bitmask,

I wanted to be able to query enough info via stats (i.e. is APICv active, and if
not, why is it inhibited?) that is exposed via the other interfaces which are not
always available. That unfortunately requires a bit of "overloading" of
the stat as I mentioned earlier, but it remains cheap to collect and expose.

What would be your preferred interface to provide the (complete) APICv state?

  but a generic APICv-enabled stat certainly
> makes sense, and perhaps another for a weirdly-configured local APIC.

Can you expand on what you mean by "weirdly-configured"? Do you mean something
like virtual wire mode?

Alejandro

> 
> Paolo
> 
> (*) you have to draw a line somewhere. New processor models may
> virtualize parts of the CPU in such a way that some stats become
> meaningless or just stay at zero. Should KVM not support those
> features because it is not possible anymore to introspect the guest
> through stat?
> 
>> Tracepoints are explicitly not ABI, and so we can be much more permissive when it
>> comes to adding/expanding tracepoints, specifically because there are no guarantees
>> provided to userspace.
>>
> 
> 

