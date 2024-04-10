Return-Path: <kvm+bounces-14061-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E09389E7D4
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 03:32:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7833BB21DEB
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 01:32:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECB8E1C2E;
	Wed, 10 Apr 2024 01:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KVVxxQ05";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qVxdQ4pI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F66FA5F;
	Wed, 10 Apr 2024 01:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712712724; cv=fail; b=S68INWbBQLGGzjlNVR/eiwGXnBkGw10ahBBWdqQK2ycWXz5yWKebvUOdJxAu9ZoIpAFebYp40Stgthl90pP4z2THfca1N9gtFH906f9x8GepdwCzzQLj3Cp7fdqqH2WS/IPg416GN1TD3PnpDjjumJQ/IfLvmiNgVZZofQV1Z7k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712712724; c=relaxed/simple;
	bh=xiBd+3gfxEtiHzA6mUu0vRvrCwbUkdwU9s1pWLnIdE0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UOG5Gri7Dteku9eYpjLkTgOZyDQqLJo9/AzdWnfZYTwiTrWOo4t0AhdVaiCsJNkpsEkTLMjLvtpRrzn9Mz8ASD1zLVPo9Cd2H5IuwQR0Mb9jHPV1JKbPstba1MuklgaqbeR9HklBIq/3ULjXwhfao/TAddsv2ZvfLrzzncfexSs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KVVxxQ05; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qVxdQ4pI; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43A1F0UQ031543;
	Wed, 10 Apr 2024 01:31:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=788JGESEkezGUArEdWzKO8JgAnXS5MWPJnWRiGUOxfk=;
 b=KVVxxQ05LX3YfHmm7Uq8U51B8C2QiPEHxVD/0B82fQO4VTFvBLTDfJ2zWXrAsFCOFWlc
 k3Zd31tDpIquzx4i+pGIq+3V1bmsZJWGg8Y8ZicbUOqELbw55pVw0FwlEk6Z3nGg5otp
 MRU0RnMgiE9TQbqjUjlLL/L/yyBmE1HsWZi/S+iZggNuPPFzS0cCODv6GngW2GcDMuIj
 lfIIuxiE79G6WQyl3Ns4nwSxJOe9VGBhhn2aIiumaqjwGUxsyTpCbvQngR9Z+AIpV3IN
 9TF9uLRu6DRwcan1Jmab9YdHBjZw0T/xBoPZvlznHvY1SZ/VLsCN5VaVG/4Psetjjo++ +Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xax9b680b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Apr 2024 01:31:55 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43A1Vq4L010592;
	Wed, 10 Apr 2024 01:31:54 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xavu7g27m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Apr 2024 01:31:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WrAJ7IUHCRmm+TPWfmZ4N2ZK/qgD+XJHzXW+SR3qI5yPcBrr2JZ7tWWPK6vUbEK+JsUTOjxKAUB1mAFNdOPMMySyleSl0Nk6fRqd88YMymdBQDatFVLrrf2OVy9yKBS9ty1C4IXLue8g6/y4LetXArg8UDzpMvIr24PcPlKF2hsLxuy2SNLLnHbao4a7QUfw3orcaZPAwe+iG+LgDTyXJG+cyXr4Pbhbtd9sn8WzXMP/gNsdbAunqIyWcmDkIil4rOtHwN+l60DKk/nqyK8xo6H9qRVhIwecunmdX6nYk7/5SOXA3PHlmJNazMc80ci8bjnExEoH38uAYv7XhBLSVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=788JGESEkezGUArEdWzKO8JgAnXS5MWPJnWRiGUOxfk=;
 b=BFxeapQeEkSjQUjiRDN3iUPXi2jyMo9mtjbvrpcBqeFcUCBM0zlZdMkogjTUMLJrPZn7hvNtWFAW1INYXqGZk/hf/kcFqnSspn/KiWuzDNfg422U2yiRDRUz8P0rzO3MaJ2gdYnEVQU++WjdZGlPsQRsItB/oDkZR0rOyeEeH7PW4crRidbrx1OGrNx1QtRLI2WCrFfS383rjC3OXOSLhE4iEe556qIwuhLt7FQVJVi5svjWYAxXN+sbEA5cG//XF12TdAwni1NmQUFXiAALNRL5qMLJg1aNJ/MJqLbyxQisiBq2LEaCS30XR//+xpufNAnfgqEWO8OzCIZoa4X11g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=788JGESEkezGUArEdWzKO8JgAnXS5MWPJnWRiGUOxfk=;
 b=qVxdQ4pIcrJ6Nt41jv6lKEIfARsojRwXklAkYd0QTd1TyrGrpdFSxnOrdSMojJWzo8jHjFgBJQGO/RVrvEQVkm3L0IsU6k9VwgF9TLUe1eynNwxxrQyfJ4hImbqCJ6NVkjPtem8kX163PQSxlEXxV4JoqdGokj0wS0VWmTvg1Do=
Received: from DS7PR10MB5280.namprd10.prod.outlook.com (2603:10b6:5:3a7::5) by
 DS7PR10MB4927.namprd10.prod.outlook.com (2603:10b6:5:3a2::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7409.55; Wed, 10 Apr 2024 01:31:52 +0000
Received: from DS7PR10MB5280.namprd10.prod.outlook.com
 ([fe80::c7cc:f6b7:386e:fd5d]) by DS7PR10MB5280.namprd10.prod.outlook.com
 ([fe80::c7cc:f6b7:386e:fd5d%6]) with mapi id 15.20.7409.042; Wed, 10 Apr 2024
 01:31:52 +0000
Message-ID: <98493056-4a75-46ad-be79-eb6784034394@oracle.com>
Date: Tue, 9 Apr 2024 21:31:45 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 3/3] x86: KVM: stats: Add a stat counter for GALog events
To: Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, joao.m.martins@oracle.com,
        boris.ostrovsky@oracle.com, mark.kanda@oracle.com,
        suravee.suthikulpanit@amd.com, mlevitsk@redhat.com
References: <20240215160136.1256084-1-alejandro.j.jimenez@oracle.com>
 <20240215160136.1256084-4-alejandro.j.jimenez@oracle.com>
 <ZhTj8kdChoqSLpi8@chao-email>
Content-Language: en-US
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
In-Reply-To: <ZhTj8kdChoqSLpi8@chao-email>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0071.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5d::35) To DS7PR10MB5280.namprd10.prod.outlook.com
 (2603:10b6:5:3a7::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5280:EE_|DS7PR10MB4927:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	t0acVmrXYAWQYIthpMrQ1fMY6oEZrbsUmGF6guJSmFWH8fYovov8NNsnMmqixVjB4+JwyCqAksqHiXaxc6nchUHIsnyvsCbUG1yYRZsn+k/NucAuwZAF7zVNCSz0xEZWbARcpQDvSreeB+yyRRdDiW2RN6mFDM2s8M47RPZkEryaaAUrGWiXiuHNjCldaz7L3QGgFt0k08FkWlq/AWbNkgByRUaADjhZaPk3W1c/HQb7v2laMZ/ye70iKbt5x7lKVKxiTUlny+SE3NhH0V/moStipmTs2bBdGlz4uSv9fW8Oy1SINgxgd/WNKI/LT+u8DFAKXsUAF6YM4MrwnIuUY9BbMEpgfVOHN8LcVUrKRuulgkjmUnX4wSckYljaD+v+hG7vu4Amx0ueA0yOj6teno3AvxiRRy17SbGDObTrARqK8VirbN6s+gImdPukJeMX3QQW+iY5IvpBlpWHPRBZBGazn6bNTQQ2t3GFYjQupd4S4xQqeVYABmPmnnc0r6RyOe3++6UpyBOM3FOd40Mk5qgI5rtrR3QSJVbJqifx14v1wOB5TRNW2mYqfl4fjdNVlov49wCNyX6aMeRIS2rO7eU3tGezcTvwVaEDR/jgrCpt7XgcMMWAAyFkbfVKyE5eLrOiBD4tIgkhk830H8mYA285u/Dg8/5OTs9PEXMlVOM=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5280.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?TGwzUmFCWmJ4R2dNQ2lOZVhUeTFTb0dBUm1hM29VbnRJRVlVYkNiRG41RWRP?=
 =?utf-8?B?cnVjQXEvVTJiNGEzSHJPemtpQWwvczdyTmdJV05ZU1pVUFoxZ2VvOVRKUkxR?=
 =?utf-8?B?OUNWYU9hNnd5ZnI4SUp2ZmN0d0lteWhQYy9vZkszTVMxcXJFdkorM0U1d2dO?=
 =?utf-8?B?L01BNXptTjRXSG5TQS9RRktoVkc3TnJMWlZHUU8zMzVNdXo5L3hrREV3aGFp?=
 =?utf-8?B?V3pHM3QyWEFJcXU1OS9EQk9QREI1NUxvVjZ5NVVkMHowQ0lMMGE5TjBnK28r?=
 =?utf-8?B?UWdLb0lpdHdqRE9VRGFuZVlFc2l3T0tydGQrT2dXaFpBQ1VmQUc5T3pMK0Js?=
 =?utf-8?B?Q3JwOG9DanNtMmg0TE1ackpNNFVNZjBVZzRWQjBJcElrRnB3S05WMWJHVC9C?=
 =?utf-8?B?aGE5SlliWXY3VDI3ZG4zQ3NjaTFoVGpUVmlZaWFYendBWXI0ZmRTWVFpZHdQ?=
 =?utf-8?B?VTgvMkVVSGtKS3k2UndrQUNmMzRaZE9EVWpyajJXYmxRL2g3djRBR1VQSEtY?=
 =?utf-8?B?Y1dpaDJHTXFKSFF1RCtPNWN3ZS9mRWdzaTA5Q2NyUzY2Q2VvaG9iSUkwZHdY?=
 =?utf-8?B?NVV1RU1wUkhBZldvOGxVMHJwWE5VSmxBYkxwMjlFcFZPdy9XNkRQcU5CQU9F?=
 =?utf-8?B?ZTV5c29Uc29oSWUwQjhzZmg1d3lJa0MwWjMwbVRPdWExdGZQR1hiQTZCUnNF?=
 =?utf-8?B?cHFSWjFSYkQrRnZxWmRDdVBmUGlEK3pvS0VpYzExL1hQbFlNZmVjSkQ0YmNE?=
 =?utf-8?B?SCtPQVVWZ0tHbFBDU0hrcFFjeUs4SkZ6UFNPb0tLZnBiWFdpRlkxeUlQa1kw?=
 =?utf-8?B?ZmF6d1dpRHNwY0Z4c1BWa1k5Y0xNZjdsSmptM2pYY2p5RnVrZXRTYVl0TWQz?=
 =?utf-8?B?djBhYmlUcUVBV3RjYk9ocWRsQkFCeEpQS1R5T2U0cXQ0T245MUV0MEdhMURk?=
 =?utf-8?B?dGkyWXdSZ2l0MVhnOFQ2ZUhoOTgvcHZpc3VDK3JIaTlYeFRGc3prVC93VlZl?=
 =?utf-8?B?R3cyMDJCdUVBanFjZWk2SStrcWVtVUVIWTNZNDFQZllhekJIY29MYlQ4MXVt?=
 =?utf-8?B?bkozZFI3SjJXM01PWnRGVE9ja0xyMEFnNlhYS3prWDMzc0hpcHZtKzhmYUF6?=
 =?utf-8?B?SXVXZ3hoa01uOVZHSDFhbUlZTFZsTWw3R3dhbUNDSEI0eVV3a0tQVTI0S2ZL?=
 =?utf-8?B?WjRTNnFaRCswTlNTTkhkeEt1MWU5VDVQL0o5ZnZsMTM0S0JTVFJpZGRmMGl5?=
 =?utf-8?B?aEUwS1kwZGYyYTRQamVIcUhxY3dWREhXYTB3eTQ4Zzh5aEtoeXBWclBIeEdF?=
 =?utf-8?B?QWpqTURHeWo2VDFsSVo5NVRaQnAyT0tpaHlsTFpTNjVUZXlGQVNaSjV2UWZp?=
 =?utf-8?B?bUUwUC81WXpUQ0xpcHNpQnJCQitDWkVsNk14b2dsMFhjYTR4elBZOERkdjM1?=
 =?utf-8?B?aWEzRUs0ZERWWk5rZWk2U1JnMFNjN2ZtT3ZxeTNOdGdkakNjWElMTUQ3TzFk?=
 =?utf-8?B?Y3p5VUhIaDhHdnZZWmZ6Q0tJS0xwOXN3RkpLVVpIaGE1R3QvTFVwZ1J3b2ZI?=
 =?utf-8?B?SW9jUlpOMmRJQ255bDl4SUVIRzFIMUR0dEVuYVNLM1FlRys3S1NDRTJuaWhi?=
 =?utf-8?B?UUFxSjM1bnRBK0IxZjA4YUh1cGJZR1RzSWZ5M0dPT3c5UUxLRFZRR00rNTRV?=
 =?utf-8?B?eE93SE9jcm5qNjRJaW5uank2SmliWmR1TlFXUGNZVGhXWnZPVU1xemNXQ1Vm?=
 =?utf-8?B?cDBZSlFLR3dtK0VIbUsrb0dEUjk2QjBvTnRtZ0d6dVlQc3B1aVYwU3VFNlhE?=
 =?utf-8?B?L0RvenRTMTNQaVpyZm5QUzNtSTFNR2dSZ2NVU2lDN0pDMmJuV2xyWmZ6ekMy?=
 =?utf-8?B?VVhDbEJJbjVvMzZ6VXZ2Ulg0eUluZ3VaeW5qcXNFSmZjWUpxaWMzbnlkK3p3?=
 =?utf-8?B?RUcxanllWEJ5bEFxZ3Rjc2pEUUFUNGlqa3gwM3VRZjNvMHBxakdnTlNJdWNN?=
 =?utf-8?B?aFRCRXQra2MxbVFlOERYU1FobFpXaVJwY2lnYmxTeCtueTY4bzhUZG1wWUZZ?=
 =?utf-8?B?RG1XeElDK0g5dWVsSHJJNGlGNTB0OGc4eitSd0ZFTWZSMmJzYmtnTkdjQnFO?=
 =?utf-8?B?cE4xSFI3Zm9RL0Q3bGNOTk9McnNuZHh5eVNKRG1oTVNUUndpY3puY2VZTmlS?=
 =?utf-8?B?ZGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	QnkKklAeNRiI/sULYUxEDRwx/56natIFJ9ZNTDDmPvsTaPWGLCdJepDNvfEGij/zfjX6UHxJlDhCt1MvawJIy+HcK58lHU46VTv4CFeUlZwCH8pw4pBbD09IIOhfCDxy9iuhQA8u/90RyAHq1J+oOM7L0mBWxi6qYcIvL5dxlcm5IBYvte452WwziYSPS0+fLTdJNrBdP5veHB1fgFEnHwEKAZmgl72+VAjhysbonL7NdXNoZpvdpi+XlcGI3QX+gNwjnEV/vIhZRbPkf93Mq/cZpGjiym+VU2By/jWmyIIfCZOUO05nk/z8uXFqllzlKIhMJGvOMGp845ZbpitPe+PcbMB+WbYLWEbLREUoDX6qaBZ610vlBiewk1BTEcKclkw1FksfkX92K7kmqw3HGnp97tVK1QjSlHXmW/Z/HaCFvt2+CipiIq8hc7z9vH80nHsgePNyh5jxcLUyt/xwMY1TixFDF3Y0F4tREosY8dn9WI+8ApLsKo/uGS70TFXpMz/SlN3MJxnsmRuUlxDOfWXyiYmu6MV/Uh1x/Euz79YE7m1leJPRcXOwRVtyVp/qVAZn4HIIqxnX5FDwDDbh3TBXj6CaRos+6HRa8bRmLBo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c5e5673-2114-4aaa-6cda-08dc58fdffc4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5280.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2024 01:31:52.3935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QbhKim65hE7XxkqOXjhfKMYpi7q0OsP0l+pU5OeZ8MDch76HwNzMFb7ETK2K+Q937yeiR4Yv3AHhJolmap7h9qQHnO6SiobYtp4s1QJ4lO8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4927
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-09_12,2024-04-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 spamscore=0 mlxscore=0 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404100009
X-Proofpoint-GUID: aNR12FLWspkRq_ClfwAVYn4kgeoInLLh
X-Proofpoint-ORIG-GUID: aNR12FLWspkRq_ClfwAVYn4kgeoInLLh


On 4/9/24 02:45, Chao Gao wrote:
>> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
>> index 4b74ea91f4e6..853cafe4a9af 100644
>> --- a/arch/x86/kvm/svm/avic.c
>> +++ b/arch/x86/kvm/svm/avic.c
>> @@ -165,8 +165,10 @@ int avic_ga_log_notifier(u32 ga_tag)
>> 	 * bit in the vAPIC backing page. So, we just need to schedule
>> 	 * in the vcpu.
>> 	 */
>> -	if (vcpu)
>> +	if (vcpu) {
>> 		kvm_vcpu_wake_up(vcpu);
>> +		++vcpu->stat.ga_log_event;
>> +	}
>>
> 
> I am not sure why this is added for SVM only.

I am mostly familiar with AVIC, and much less so with VMX's PI, so this is
why I am likely missing potential stats that could be useful to expose from
the VMX  side. I'll be glad to implement any other suggestions you have.


it looks to me GALog events are
> similar to Intel IOMMU's wakeup events. Can we have a general name? maybe
> iommu_wakeup_event

I believe that after:
d588bb9be1da ("KVM: VMX: enable IPI virtualization")

both the VT-d PI and the virtualized IPIs code paths will use POSTED_INTR_WAKEUP_VECTOR
for interrupts targeting a blocked vCPU. So on Intel hosts enabling IPI virtualization,
a counter incremented in pi_wakeup_handler() would record interrupts from both virtualized
IPIs and VT-d sources.

I don't think it is correct to generalize this counter since AMD's implementation is
different; when a blocked vCPU is targeted:

- by device interrupts, it uses the GA Log mechanism
- by an IPI, it generates an AVIC_INCOMPLETE_IPI #VMEXIT

If the reasoning above is correct, we can add a VMX specific counter (vmx_pi_wakeup_event?)
that is increased in pi_wakeup_handler() as you suggest, and document the difference
in behavior so that is not confused as equivalent with the ga_log_event counter.

An alternative if we'd like to have a common 'iommu_wakeup_event' is to add filtering on
pi_wakeup_handler() and only increment the common counter if IPI virtualization is not
enabled (i.e. !vmx_can_use_ipiv()), in which case  we'd only handle device interrupts
and it becomes the parallel case to GA Log events.

That leaves us with a VMX-specific counter (vmx_pi_wakeup_event) which provides no
definition between interrupt sources when IPI virtualization is enabled, or when disabled
we have a common/generic counter (iommu_wakeup_event) that applies to both vendors.

Please let me know if you agree with this approach or have other suggestions.

Thank you,
Alejandro

> 
> and increase the counter after the kvm_vcpu_wake_up() call in pi_wakeup_handler().

