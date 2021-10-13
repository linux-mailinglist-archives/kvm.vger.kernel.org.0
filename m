Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1D142BB92
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 11:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239120AbhJMJcQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 05:32:16 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:51852 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239106AbhJMJcP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 05:32:15 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19D8JMDx004189;
        Wed, 13 Oct 2021 09:29:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : references : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2021-07-09;
 bh=v+c7S1KqQPk0eDjdX1ZKDLZuHurgjduyQNy0+fm9wqM=;
 b=Z0u431IJgkaxJZv8IaDBMb0hN4IuZalKrdCj3Ff0Z24bdg1UtocR2eMPnDBpyVt6xeN1
 mlSPo2mC1jT6tvAaP4YQLxBDASBBpnIo6Y691NPhCtZKkczzceQuZTDF+BmYvXIRQBdb
 TlHwZBVdBgTPUgHoIlxSKr2Xvvd7MfZDTbG8GqS9v/xlgcR8AUz9PHoT2zODs2NvWUnb
 R6UnC0eLqe1oAv/CV9wFSuWG9x9ldLU3ABEFnP2DuipXmbj2LBMoee2wFXQmJATyIEv4
 aemak0sQUMqNZF+pKxwqju7uKwl5JQ2tHyNDDfXz1XK8YUDWoRCPtjz7e/6gmv39CmK4 Rg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bnkbuarpy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 09:29:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19D9BAPv140981;
        Wed, 13 Oct 2021 09:29:09 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by userp3020.oracle.com with ESMTP id 3bkyvbr0cg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 09:29:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nix1i7CV1WSlrQKl2m/DaOw7PjbTVsLD9ixm4LwNM/95dkHrfGlLrKEud3soERSzL58dp+TiS6+TsU1GK+48MbLp71AIV3n+/h29G55CuRpyo2BWyA882Ckln2WcCMheqqGipE3kV54ZBJOosaKa5uWchBR62IvOx1rBUvr1GSxT7JE1DMQtk1Y+u62QGVrQAXXpn+19uRd3BTqe6Qmwkt9/Y4NGUA3om/fiztxgPaX3mD2WHXP3KyqX0Vt6RGT5xwYk1EMxEpDh7F7ZUlhsgz6+SdD+wuPsrI8+pfGfHaIZQJ9sKiWFnfSShHsV42JvYpJmzdqsvN3TNCEUMgWfzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v+c7S1KqQPk0eDjdX1ZKDLZuHurgjduyQNy0+fm9wqM=;
 b=QCnul7DoBAglMhgEpqUpv99bhBBJ+wUKJCf39YGLqTIkHAuJ+ode9g6lRci2sZlNWhBKCR9yKbNs2bLIi2sCgPddz7zm09xHC3KXpq7KyUB7uDnhlGc3gjXldsKhlK0pxKJ4yhYmq8z3HQpO/SRSV35d/X05CeGEPAcXygQOT1kqSEa0IMSi3IuFGFAoUgprL88Ka9ECV9KPjh3Mqjgz/y1KrYOXtF6Gd7IZ2JCQLspQuiHbLpq8CUkooncGb8ooxsQ+xpBgVofuZwcmBd9iLk7zh3EsVdGorQhLhnkQ8yVnHGHtA17I5Ad/yE1sZZ8RmIbK0iuMpGwo3zGNlh1AyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v+c7S1KqQPk0eDjdX1ZKDLZuHurgjduyQNy0+fm9wqM=;
 b=DENciPRJpclJpTTdUyrCL4P6hWYPIQepGK20565mcnAS9GBIeFx3JgAwsZHborveY7AWmbJl6vw98bvk44FH7/Qs8pzxHEDMeHbp+OW89/X4ZsOF5Pxse975rlH2yq3vCdcjl+0C/FV+OnXT02vtpGpMUPZlMgWsRcNig97fezM=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3148.namprd10.prod.outlook.com (2603:10b6:5:1a4::21)
 by DM5PR10MB1611.namprd10.prod.outlook.com (2603:10b6:4:b::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.20; Wed, 13 Oct 2021 09:29:07 +0000
Received: from DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::6124:acae:c33e:1708]) by DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::6124:acae:c33e:1708%6]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 09:29:07 +0000
From:   David Edmondson <david.edmondson@oracle.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     David Edmondson <david.edmondson@oracle.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, x86@kernel.org,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v6 1/4] KVM: x86: Clarify the kvm_run.emulation_failure
 structure layout
References: <20210920103737.2696756-1-david.edmondson@oracle.com>
        <20210920103737.2696756-2-david.edmondson@oracle.com>
        <YWYeJ9TtfRwBk/5D@google.com>
Date:   Wed, 13 Oct 2021 10:29:00 +0100
In-Reply-To: <YWYeJ9TtfRwBk/5D@google.com> (Sean Christopherson's message of
        "Tue, 12 Oct 2021 23:45:43 +0000")
Message-ID: <cunfst5ff37.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/29.0.50 (gnu/linux)
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0206.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a5::13) To DM6PR10MB3148.namprd10.prod.outlook.com
 (2603:10b6:5:1a4::21)
MIME-Version: 1.0
Received: from disaster-area.hh.sledj.net (2001:8b0:bb71:7140:64::1) by LO4P123CA0206.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1a5::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend Transport; Wed, 13 Oct 2021 09:29:04 +0000
Received: from localhost (disaster-area.hh.sledj.net [local])   by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id c63ce640;      Wed, 13 Oct 2021 09:29:00 +0000 (UTC)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4881519a-9ed3-4b59-27f6-08d98e2be761
X-MS-TrafficTypeDiagnostic: DM5PR10MB1611:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR10MB16110C99A1268A914C445AAE88B79@DM5PR10MB1611.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: REqIh4xGHe0+o7iq7OWUUANG8RTvPRLBeskjiIUEWUnVSKtAS/auWpAPqeDnNi8QYPG05g0QmwNl3Sz0eA+VR0qTLmT11JjSe8yGi8z6BV0YgpRDVqBuzZsKgTOmZwQK7MZbice8FPJsuySNqqYm/HxVNd+e9TT2A9ip+SZl1y5UH7HD8yqV7sB3jENuMzRbifMy+hTIBn8DTV98ITXP4emC1czJMp6kVEL+gdrdaV94idJINBgCcBWexwPhKwQRq6t57qkGss20ikq62rgBxnzqymT/oUxJtaL9OFuY0CAi41U7B9N+oe7nv/HWgycb90Zq0BqsevyIPp1T0wXFjYiUBvAB562nwyQw9RchgAZ/OoKFsZtwshJKQDoDTIb2krmdmPAPUHl6/Y9G1CRyO3ml+L2QDttyvJIUJzWry0qW42D/N42uTOtS0fJIWXdYob84vuKOSaxWp4JdE0pxnu9WAX13avDo488wgwWUjVNO/8p4QVB0Cmt3DND8+fSaIBi3CiuKRKkDtXr9Wk/iS6DpEqgajvODlYGP8l5NG8YCRrkbXGyrMlbQ2mnlN+1w07KwWYVzZKE/CAsczyPOsHnpGMDa3p72qnFvosneokEgBq73cDzY6TdpInHGfoCHY245n+tdNPtOhjOhCArDwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3148.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(6916009)(2906002)(4326008)(66476007)(36756003)(8936002)(54906003)(52116002)(4001150100001)(2616005)(66556008)(4744005)(7416002)(83380400001)(508600001)(44832011)(8676002)(38100700002)(5660300002)(316002)(186003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LINbuNsiPRzh8Tyh1V1QBYRqT+2axU5clLbrzBvE1yGt3WVBP6CKnTL88DOk?=
 =?us-ascii?Q?MRdky2jYYjWuVEe6/jK6Zu2UAtwzFHlwjdYZGcpBLof/BKB/vba1sTnRHjFL?=
 =?us-ascii?Q?eNK7cQBlW5D8aPeFKuifnTJnaH2LUCgVRvsGcAoKI9vA0ddmnxez+KUp21wQ?=
 =?us-ascii?Q?Lqc9JKQMnXyrrKpkEdwDt5tDbBOaneisdgTRLlMn4ctO80qnKbFX5lcu7uhO?=
 =?us-ascii?Q?NhKNOfEXrOSZIdiB5zReHEWvIb1vBSBqTqzZ7dM3HQ73g8d0v+RsS5eEM58T?=
 =?us-ascii?Q?0aNqyAmZO3Cgy1bbY9Tffsz5dDPYzOLG7IQ40gROwvG0mQ2sDXv5Cv3Z0sy7?=
 =?us-ascii?Q?4acOOn4tnO3Y64D8dq0RlsnYxnps2g0dwwt4NVZe/Rs06R35pdcAcGRb/871?=
 =?us-ascii?Q?1IOL3OWIQaRgE8Q0T3NJ9Uneaz3gxmWb8SbrsNBbKNmqEC+lN/N2zP7WL7tU?=
 =?us-ascii?Q?yw3xvtZncSjNBvdT8hAQxDIYVl5zsGaKotbwM/yxtqovzT/7gQxdGI9U4lP1?=
 =?us-ascii?Q?TJmXpMr35Dh9NV7seiDUCsUSupm3xaQTwppSLYJht8pL7UxrI73+TsM54O+v?=
 =?us-ascii?Q?bAlVDalq6miubWK22DtEYSETmk8082W9bmtVszZre87geVLkZLkjJwEmO1+z?=
 =?us-ascii?Q?AQ+nGfKoHHRuBi73vbDoY0FopcPGn21dFIfxj/MyRLnnjKmbv5jyvns5uTvi?=
 =?us-ascii?Q?WKSDTeeVUUpQv960CJ2wQSzZBgDeavyVHTs5r41Q+ZcPqKgN5WeDX3CS2IsD?=
 =?us-ascii?Q?wsuSABs8zx8HfWcMR6lag4ARO1jTVcuucikrQ0z9ViGITZsUOqX/s0bN+6rV?=
 =?us-ascii?Q?drOLdX76X+rAsjnCS1mSrT468CxS7+XBZ48PCu+qTTI8xdEDGPpLTMSMQbwY?=
 =?us-ascii?Q?fir5/T4GmDKo8q0ZxPyjroTXp5TmHXyUWA5T2Y9NRIsrKsbhlpzKixpuVWI3?=
 =?us-ascii?Q?q7mOOevdT8UuWPEQAuG57FeUrJGAcjBt0GQQTsJTnuSD6y8HzTqnjcrGcfMh?=
 =?us-ascii?Q?HudKbDxTYqDDF0RgOJOYlJP74bgXPTiqLtp8QgmHnB8t0/GtW5AkZVUD1Ft2?=
 =?us-ascii?Q?hoqMiq276V/+w3m7II5hXV0T0UU1UcWZuwz4AOHI4gIQtzfhZJi0i5lDAyCJ?=
 =?us-ascii?Q?eNlcder27VzKRcNPM2TZH7tvmzjhrD6RQEC29ndkgSUIbAb1E+R/XlY95pND?=
 =?us-ascii?Q?5P6dzSraa/CpD9GTP48MWWYWE8FUz5++YEZbPXM51nr+LpTUwmdlPxVAWd4F?=
 =?us-ascii?Q?edlyM+1qvHGPWcVpzP+CYPyNEejnuUymidokv2SKwXOxls7jhITae2yGreRZ?=
 =?us-ascii?Q?qZJnPdbA+5GWJI8L9I3c9Zu7vipYdxmaORZocR5bfp12AA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4881519a-9ed3-4b59-27f6-08d98e2be761
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3148.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 09:29:06.8956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nrJi21CJLX6Qtii/Be1bDAMziT2B1TLWHdrg0Nt3SCkpk+hix8DXiEOlMiZ9UOoUsSrGRwAojHmz4Wn6nwbQrgSOjXe7eWv2k6qU2x4/B4U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1611
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110130063
X-Proofpoint-ORIG-GUID: nNSRVsKt1ZTXCNdEh57ZZGh1qoXG-eAK
X-Proofpoint-GUID: nNSRVsKt1ZTXCNdEh57ZZGh1qoXG-eAK
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tuesday, 2021-10-12 at 23:45:43 GMT, Sean Christopherson wrote:

> On Mon, Sep 20, 2021, David Edmondson wrote:
>> Until more flags for kvm_run.emulation_failure flags are defined, it
>> is undetermined whether new payload elements corresponding to those
>> flags will be additive or alternative. As a hint to userspace that an
>> alternative is possible, wrap the current payload elements in a union.
>> 
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: David Edmondson <david.edmondson@oracle.com>
>> ---
>
> To complete the set... :-)
>
> Reviewed-by: Sean Christopherson <seanjc@google.com>

Thanks!
