Return-Path: <kvm+bounces-16356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 381EB8B8D8E
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 17:58:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E3AC5281F3B
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 15:58:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E686E12FB3C;
	Wed,  1 May 2024 15:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RjFyqt01";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iEtoSBrG"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D65212F593;
	Wed,  1 May 2024 15:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714579083; cv=fail; b=aiQSzP7ezF7YWY0YGVNQQCdO22OImRV4vlvXSuz9zEoinSSe4PAGBlS8GVrjZ88IFfS4JCaZS/AEzKPWLfSMTSh2FBsNeQmmnJOlHUWqeAuRbZ842ukxsLiCWlMO+Bk3AOzhLDukc82JH5eeP78aWLg9Fz9Fndv2FlmvnV6JOW8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714579083; c=relaxed/simple;
	bh=YYm5r3RIaioTJCDrg7dYG8wIkPZATzTXAOSzxa/d1JI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rooy86znz0u7mnXLU6LBTyRPSlWB92QZt7YqKZQ8MAbR8Wjo6jGEBK9fMCj6nomyyVZfaEJXNxptMsCX7wnqWZaDA8W3n4/eVgp/lxRlDW+x5i4SscmE5Tyx3woTRnBMhGTObZjsUHbYJmE/OWWaKfTdyA4+3+WazK0k2XGfdtg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RjFyqt01; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iEtoSBrG; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 441ARpUH014742;
	Wed, 1 May 2024 15:57:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=8wYTwblizp8OkkY8XmK1qn67s08eo0pcL24mUK/JnZE=;
 b=RjFyqt01u+XUc6AgEflfvgPwgjar1wpiQ8JDZl4vIursg3by4HKUTl4+mpZhmVh9Zq8o
 C4j94gHLI5UY0L482p6hcmVnxev3xyMpW7dvoS5eWweqhGrE0xc9SEWlU9ACPDeCQuSs
 V2MevvrdMoLL2P0K+tqY0dh20x9vxoN9DSkuO75WBXdd2uoVllVNXai4Onyc0fpPAXC2
 fOP0qkF1uncnUqPgSlq4qQyuzQSbtyCIeXwq7zfv/J5TuYzS/3kDBuyRpy7lYaqqYkQy
 JRoQvtmPpbC7KghvZlmqpeNVDuxo4hrxhhRP/OHNcaZWUXm14/4OruZL/FFu5ldd431F lA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xrs8cqebk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 01 May 2024 15:57:43 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 441FoieT005145;
	Wed, 1 May 2024 15:57:43 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2041.outbound.protection.outlook.com [104.47.57.41])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xrqt8ym2s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 01 May 2024 15:57:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P8Snlqb61vVef71NzqHjdmT8tJCS2kTPZAFHS/CcLeQ1+axARE5vDXRSRES7ShR5bC+l+FfuUfxpdkfrzTUgvHSHNvVZ7xUUPklUudRfBWiQYSJL6Q3MBSAIV9pOAiP/u6dHPGVuyPhjyKmlTjwYSWA9mr6EspA3f2OtkPUjoguOLhtjpd6XuZO3Tx66KjB1ZIWoJM56R6CBJv33dIBaW8ZWTFFcmETQznx9XnRWN9AzD2AKWhOfrganglEFo/FlT2QdlvSaTmSgNUiCfk50A8g+/SCftlFbFmYaMlNr5SU8ajWXUdwWyXKp/2AESfusOfivGXkjVoy7VZZmzL8miA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8wYTwblizp8OkkY8XmK1qn67s08eo0pcL24mUK/JnZE=;
 b=K11NazgTvWIF3SXvQLKXdAohFN6mIlQChx5q/fxaLiNVTn5NIqafgaI2jREdDKGLRmyKxYPy1/D7L7TSrRTNx9cTEn0wNUZLQOe4jhegTnWF12l2rRULjfgY6Ulfo6or2n2Jx+7txRi5lpWgKIQHvCoRr9DfXBXhWbpELZEicBfVLf+OsAj6H++bnReo8lSpt+jL7AQxfuCfW5KBi17apDWINcJdBiJbl5YJlCGyXVGusgDevEwm8NcTZoACrE3J2Ijm5nZtdOaBQP1UoEZlbEKvbbGkv8xTLWpy58J9RCYClQsyfMunaAuhRsytRWTweQ/5K3u3qhbfsECgXdeHgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8wYTwblizp8OkkY8XmK1qn67s08eo0pcL24mUK/JnZE=;
 b=iEtoSBrGB2F/zAKsSzsoMWV3m4W6p8IrY38n7IzUNXJV9f5JrOH1KKSC0iuOdawLHK9armJCxt52L0nG9ewJj5LEiuUuSait4sozcD5HLq3kE4KM0YlMjv7R2BOuvpgeey2Dk5CiG9Q6u/ASZpAELunQrYGF0yXL6iJayJ7I9Pw=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CY8PR10MB7338.namprd10.prod.outlook.com (2603:10b6:930:7e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Wed, 1 May
 2024 15:57:40 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%7]) with mapi id 15.20.7519.031; Wed, 1 May 2024
 15:57:40 +0000
Message-ID: <6971427a-d3ab-41c8-b34b-be84a594e40b@oracle.com>
Date: Wed, 1 May 2024 10:57:38 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next] vhost_task: after freeing vhost_task it should not
 be accessed in vhost_task_fn
To: Hillf Danton <hdanton@sina.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: Edward Adam Davis <eadavis@qq.com>,
        syzbot+98edc2df894917b3431f@syzkaller.appspotmail.com,
        jasowang@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux.dev
References: <b959b82a-510f-45c0-9e06-acf526c2f4a1@oracle.com>
 <20240501001544.1606-1-hdanton@sina.com>
 <20240501075057.1670-1-hdanton@sina.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20240501075057.1670-1-hdanton@sina.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR04CA0019.namprd04.prod.outlook.com
 (2603:10b6:610:76::24) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CY8PR10MB7338:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e48222c-c692-40ca-b059-08dc69f76de1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|7416005|366007;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?bXA3amMreW9keStPbmdueWZVNXZlcWFDU1ZxZ3Iza3VZRDdoL0ZDNDQwNEx2?=
 =?utf-8?B?bmpZckhqYUVsSTlyVlY3d1dka09XOG9xNG45TTZNSUcyTSt5RGVuMHZtMisy?=
 =?utf-8?B?T1NERVRPMUZHNU5pVFJ4bTFJZmZLQTZVRnQ3ZW85WHcvRnRxWHBzU0tWMUVS?=
 =?utf-8?B?RU5sYzdDNWplTFZrOFV4RTMzbVcwMjZuK3hlWWZLTVhSaEdZci9QbGxnbmxi?=
 =?utf-8?B?OElaWWFyNU40UkJZb3o2cURsOGZOOEdMOGtZcU8rRHBjQVlpMGhBRi9IZVQr?=
 =?utf-8?B?WHVnL1NUbWxHOXVUK3pHQXoxemxoYkI3aGwwVjUweUdESm9icEM4K29zM0dl?=
 =?utf-8?B?bnQ2ajBtb3FwWS9jbnJMd0E4ZXNFOXdqQVdtOU9DVHFzbWV0MXZIQW1mUTh6?=
 =?utf-8?B?bDhaYnVtVEFLcXY4UmRXeXhFT21WcW9EL1BzVXVNWnQzaGcrN1Mzc2Z5TDRC?=
 =?utf-8?B?M2g5N0lubWIxdXR6MVV3dldhNG1nRHFRRmVIMjgwazd6MzFCYlFTRmtPNXN1?=
 =?utf-8?B?QkdWQUFMczVVRmc5VTFyUEhWV1Qvc0hua1cycDF3SHdnTEhqVEFVQlFxRW5P?=
 =?utf-8?B?d0F2bm4xOWFZZFpxb2JHTStWS1BzN25qL1BYbW1rRE05L1lMWjRkKytoaGph?=
 =?utf-8?B?NHZQSUhrbzZPVlZVd3lQWm12eGpUUFVCaWlzeUpxYktGL2xIbFNETjJ1MUlu?=
 =?utf-8?B?bU94SEw5NzQybzkxVHZPczczMko5bHF1R0VYQjFUWHlObitOaWQwT1U2dzZ2?=
 =?utf-8?B?UzkvRE1NQjZUYlBRMzYxRDBjOVBhY3Vld0d6RlQ4ck0vMGRYdjdMT2NheDJY?=
 =?utf-8?B?VVI1QkUrYnZjdTdQdzl4SlNjdDdYVEM3UXc1S0x0VFBEQ1diNHI3SDIrUCsx?=
 =?utf-8?B?eTJ3TkFnSnkrYzBjQlN0Y1o4Ny8xRUJwK2tsMkhNMDR5S3huRHRmem1WSkU1?=
 =?utf-8?B?OXR1S3RhUnlOaHFweW1tbXNiWXZjOFEwcWk3L1cyb2MwSVlMMWRBeGk5V0tv?=
 =?utf-8?B?NDVMdHNaWFd6d29CV2V6cXNseE5HVGFSR2FpNXhqN1RkZEd5TWtocWlmTnBL?=
 =?utf-8?B?c2FrWUxoa0Z6QkZOUGo3cHQ1cExnaGtoeVZCdFdGUUo1WTBqS1djTi9OLzEv?=
 =?utf-8?B?bU1iYXBiU1ZxQmlhMnpKZlhHNVQ3ZnVONnJHYmVZTXg0Vm5nNGVMWEhUTVpI?=
 =?utf-8?B?V2p1MnNIa2h3WEszSWZmZnc0ek1CcmQ5R0hNWFlRbEVmeVg1U0dWYVJDT0tT?=
 =?utf-8?B?NVZncUwxcnVjKzE1VER6a2Y1NTZ0Rllkd0lYOEsxTlNYeFZTRTRYUkJHSTBB?=
 =?utf-8?B?cVhUNXlvRUZ0a2NzeEJXaTNtTnhMbWFSSEUrNGIreEV2SjhmRTZnd3g1YTMr?=
 =?utf-8?B?SXo5OVNFNW8xK1dtaTQ2cTB6TVVteHJtTjh6MzRTSksyTU9WcWtEWDdOc1lo?=
 =?utf-8?B?REpJcGd4SFNEaW0veVY4SFlrRjJOM2h6TjhOUnlzNVYzUFVhYTVmeGZjK2Y5?=
 =?utf-8?B?Mkg0OG1kM0V0TjR5TnNQMWllcXVmTmZ0Q3djeEdYemNTUTl1eE5vRDlMYmNq?=
 =?utf-8?B?NkQ2WU8rNGJWQ1V0Y1AyMnhBNFl3V1FTN3lIL0xaQnJOamJ6WEZrcWtsZ2dL?=
 =?utf-8?Q?JRzZRrDymRXtipyDvQ3rSX6zcQV6mySzT+mCqOhp5SpE=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?R2pPQ1NTYnRWbE1qMTF4K25uTjBtS05vMUVvQlRPQm9PbUF1NmJlSFMyd1RR?=
 =?utf-8?B?MVBTbmVRc1VGRmw3SlhWMlNKbTU5d1lheDlyOWlGbVkzOHpQQlpYenNXMmpU?=
 =?utf-8?B?c3pnQ2tvenBpS2FaM0VHR21iZmtvV3VKMy9NN1UvUDZxbnZGRGMwODZwTStr?=
 =?utf-8?B?SC96dEhWNEpKc2pFNVdiWHpmYnJxVXYvMzh6aGpYeHdDWHBxKzdUc1I4dzRV?=
 =?utf-8?B?dUd1bGduZEhYOE9xWDJSeHJsYTNXZ1hFSGpmU1RpQ2Z1WGNzOXNaSWpmUXJp?=
 =?utf-8?B?Znk2emtIYmRsaVZmcW1jVW9kV3d2TkFLNkMvTExqSlorVFQ1S2poMlJVQU5q?=
 =?utf-8?B?NFM5NXRxbGRUYWt6WUF6blN3eVNKZ3FwQVNzWnZVNURlV3lyZHd2djVaSitE?=
 =?utf-8?B?SmhkTjVWNldUYkc0SEpWOVJGbkhIanJSNGVJUnIvZUtGYTdONVBLZVdtS0Fp?=
 =?utf-8?B?N3ZUS3QzWnFoUU1uWXJpMVpwSGhNdFMyY2xydno4UDNnS1VRaHp3OGphZ0Ew?=
 =?utf-8?B?YnVoSWFST0VhR0lPRktIT2JhZ0N2TTBCVFdDTU03SnlxL2NJZVRaOHd2UlVD?=
 =?utf-8?B?bEtSNkJDSDAyTVJFejQ5Q3VQTzk2M05RMm9vSlVHdnA3cXd1RE1qcWFyYVhq?=
 =?utf-8?B?enNEOHZockpxS0k4dllpQkNqZk9XQUpJaDk5bnl6MUdhc29KbXRoUE1kRmhk?=
 =?utf-8?B?Z3hJYUhaWTdwMm1EN3Q1d0ExcTJiSHU3cW02ZVU0cXV2OFZMM2pPL1JGbk5a?=
 =?utf-8?B?RFJCYndkMi9vV1d4NkthblllcStDWjBpSU5MbDlhSW5TcllhZWcvQXV6MUJ5?=
 =?utf-8?B?OC9OUkJyUFlWK3hnZkpCeDFIcjBacENmRnI1Q3d0dUtqS0svRzdjRm1CdnVB?=
 =?utf-8?B?MlV4aGlWZ1prNnJjLzZtVU5qUllzMEJSYXFGY3Jkak1KOUpWNHZhcVd2ZFdq?=
 =?utf-8?B?MjFWRTA0TU1vam9OYjRuY2xjSTZuT000dGhDWUttTVFYa25ITkx2RXIrQnJU?=
 =?utf-8?B?TEVqWlpyV1Nlem9WUWRFaTJjaGtRQnlXR29UNFZDT2M5NkVldEpFRGpTRDVE?=
 =?utf-8?B?Tkh4c2JHSXE1dXF0Q1FFQjZIMXVhNW1QZmJmSktmMEJOQnFqN1hBTXREVXZt?=
 =?utf-8?B?K3QyOTg0S25wbFhCcm1DcThzZGgyTGlvREkwT1NDcFZiYTFscGtVRzVwZWRG?=
 =?utf-8?B?NWpFRlpTZ2ZYTmNOWUd6NHVoVkZVYzl0TEFVSkJFa01tYkY4VVg5bk4wd0kz?=
 =?utf-8?B?R3NVMXBDMzJrejJwaExBU0NTQ2VqTEd6TmpEZzFQRXFkZWZCc2krUnZ3S2xF?=
 =?utf-8?B?dkJoUWx6eUFiNWdscVJYcURMS0luYjNIbENPb3dNc002R2w3dmZ3R2pRRERo?=
 =?utf-8?B?d3VwMy9ycDhGeTN2MEp4WSsybWNKMkJNYm04Sm4ycnVWNWRPczF6YlpHY2J6?=
 =?utf-8?B?RDJpS2U1SHpucHB4bXVCMlYyMjYweDdZT3FYK0lraHBvNEVMNERZZXRCYUcr?=
 =?utf-8?B?VjU0Y3FXd2YvWEpsNGZ3Y3JUVGZxb0ZTQlR0Y25GenB5dXJ3eFZWWW9QZy9v?=
 =?utf-8?B?UW1oZTBoVkFGOExCb1JBbHB1TkZTdWR2Qkx1RWgwQXVzWGxleEE4RmtoSTlU?=
 =?utf-8?B?dGYxQmpRcVUzRmhIc1JRQWsvRUFQb2xCK25jUmFrYWdLQzVTQ3Q2ZVozUW9E?=
 =?utf-8?B?Sm1GOTZQa3pLRUYwL3hFYllYMFJ2WWovOHR6TXQ1U3p0UzgyaG9iNFF5QzR3?=
 =?utf-8?B?Y3NFcmNnaXgzaXZkNmMyN2NuTDYxKy82YWtscHIyalpKaEp3Vm1Fc0FrUm4r?=
 =?utf-8?B?TWdjK1BxOWRjdHRHeExMbDdqclFXamxWM2dYc1FtYTliaTk5V3ZkbkhkY2Uz?=
 =?utf-8?B?bGdnUndWcUhadEZPaVNZSHQ0MmxscjlsdU9pMWdPMHBPSFFMamIwQWNheEk4?=
 =?utf-8?B?clRYM3ZFYVB0N0N0TnJHTDVkc1BBQkRZa2dabGpSNERwRTFCSVpkSVAxQTY2?=
 =?utf-8?B?S3hLNHdLbEhhRDlWM01TSGJTeTdlTHArL3VwQlpNdHYycXh2cGc2bUZVV0NO?=
 =?utf-8?B?WG5JdlZjZ2k4bDJ0RHBZdXovcUZvQXJGRHlPcjI4TTVMMk41RWRlQmZNMmJJ?=
 =?utf-8?B?ekdDNmxsTi81djJRRWNjVGJFbEhwU2lFL3pCQzc2Y2pnc2ZNU0tDQzZvSlpZ?=
 =?utf-8?B?dkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	U0AjEh6aAb3spnhU1RxfxTEyMJWqsHUfuh7J/O+p6PJ1slrj2dG0k/ZGkTNcp67gEB5ZTT46dtcoDWmZR2C7ynENW67Zd3jdc4FSqZUa7atRUCE5uGqFbAoHFfv/kgamV33nWzSkUAWpv61A1D3qkjKGvBGj9vJ0xDjY1uCYSlLihC9PmoP5ew/Eg/I/sc4sa1ochkXSV4m8Gr3CrdEWzbWtEv5o+BkXnRqm3SMuSt3xjqc7vaToU5HaLUW2y9nwN+j2XDYErPArJaFxvytAVUq7awh2YVlw0FJI2+jiKkXJ0GA1ak+ns2uy+Qq1KvRK+2eK1NcmqC6khLMoKYYfsFTikZS1GjJM1xo4Ao5c+Oc+OO0+dJRMF8UBzyWzaaIHvBhkYPJER/glf5ncPvXZWYFSgWSQRbyJ+EsUYXWZYQrYg9dZ76HD5kYcszDASTwKiCDLB3JJ0rmvT+F3RJVavGcEWmw4v2MEWdzI7XnVdLeBt4sS69XN0blcaN8iEE/Hl83EYzmmG3sd70hocvSOQ6ly5S8or61/JZ6tlefhsk80IzrbugovLBSYZQG3XWj2uCUGnxkkHuXKME5+oAZ1GGcMiV7Oe/OI7soW54V6/os=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e48222c-c692-40ca-b059-08dc69f76de1
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2024 15:57:40.2857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0MxjeYJcSFDbYFwBELZgfZaumc26cy8EC7obiNjmXnTnLk18SsnC05JqGmLCP9NW1YLzFCaVKxYFEUMfTIt9bXMBS3tQdQyalp3uw1jQTMc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7338
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-01_16,2024-04-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 phishscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2405010113
X-Proofpoint-GUID: yzBd8FuK229K2A1YmS1YEM6RiOF_mCy_
X-Proofpoint-ORIG-GUID: yzBd8FuK229K2A1YmS1YEM6RiOF_mCy_

On 5/1/24 2:50 AM, Hillf Danton wrote:
> On Wed, 1 May 2024 02:01:20 -0400 Michael S. Tsirkin <mst@redhat.com>
>>
>> and then it failed testing.
>>
> So did my patch [1] but then the reason was spotted [2,3]
> 
> [1] https://lore.kernel.org/lkml/20240430110209.4310-1-hdanton@sina.com/
> [2] https://lore.kernel.org/lkml/20240430225005.4368-1-hdanton@sina.com/
> [3] https://lore.kernel.org/lkml/000000000000a7f8470617589ff2@google.com/

Just to make sure I understand the conclusion.

Edward's patch that just swaps the order of the calls:

https://lore.kernel.org/lkml/tencent_546DA49414E876EEBECF2C78D26D242EE50A@qq.com/

fixes the UAF. I tested the same in my setup. However, when you guys tested it
with sysbot, it also triggered a softirq/RCU warning.

The softirq/RCU part of the issue is fixed with this commit:

https://lore.kernel.org/all/20240427102808.29356-1-qiang.zhang1211@gmail.com/

commit 1dd1eff161bd55968d3d46bc36def62d71fb4785
Author: Zqiang <qiang.zhang1211@gmail.com>
Date:   Sat Apr 27 18:28:08 2024 +0800

    softirq: Fix suspicious RCU usage in __do_softirq()

The problem was that I was testing with -next master which has that patch.
It looks like you guys were testing against bb7a2467e6be which didn't have
the patch, and so that's why you guys still hit the softirq/RCU issue. Later
when you added that patch to your patch, it worked with syzbot.

So is it safe to assume that the softirq/RCU patch above will be upstream
when the vhost changes go in or is there a tag I need to add to my patches?

