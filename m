Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2FB3439A58
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 17:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233689AbhJYPYG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 11:24:06 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:20296 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233682AbhJYPYF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Oct 2021 11:24:05 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19PEv5Uc030378;
        Mon, 25 Oct 2021 15:21:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=+1x/G3eRNcveBu0JqAXdmKan6/3bUf7JLuQlYWPAeKg=;
 b=Qt87bVVq7s9/SmIlWDpMJPzAJkyFvrxxrxasw191wc6h/8NKgaQTq2eYPaQSL0PN5jeu
 2hdyuUnhywpjlJjr83IVVJkOyLXbHGl+/BACx4YS+rs0BUq2lPdMGaidKb4gOT1oxYuJ
 vrG6PzjG/OLNIoA0mEIj/u717XX39rzTS2t7xhPePTHZlVM1djCG66PJyEqQpPnOKm0g
 47flxF2zxuUHydmfCIjsP6ZhP9IwKWHEtO4h5TG1LOhh0OGBxp/2vJcEznjyKSqrGTNg
 r01jkepjawJ790PbDl4PDMdyGY2dDvAmfrb+yF4RjRJf71+t+qwo1vCyzFyG4SPkHTRY Kg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bw6v1uumy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Oct 2021 15:21:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19PExtT0068428;
        Mon, 25 Oct 2021 15:21:30 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by userp3020.oracle.com with ESMTP id 3bvv5s5ww1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Oct 2021 15:21:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pyzu++8HYrmVIh+drGfy7pmRuDLz9CDgqp28ySWtxn9qyfsJJUognOty6r3o6J57dA8nm9uDCiRyS3ACPhaTFxPycZFEvlWFPdNBNSJdYscO0gMgSv3rpxkPR1euSzDc09d90MC/Cqz3Q56b/2Zw8sfT1v3DEeQYKzMm024CGOJvcfMZFIRQ86zrPZeXR5juvbnEJ2TabJk1cVgZ/RPFG3NrSm3tqqTvmVtXqUPmmKxfjfG/9gewy/3ZoGiGoRTTX+5yj/W39jb/wQt916Lj1avQAeOOB+wA9Rquargk+7cCwdq7VNweYsxq503dgLRKbSGbfbMDVa68sIiTJgiJfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+1x/G3eRNcveBu0JqAXdmKan6/3bUf7JLuQlYWPAeKg=;
 b=gv24MTTvtQY8Rp8Tjmgl8JrhEJBdvyImwhona0E08t53GXn8ANybsuL2eUtlo7e79DJYZkr+heLMEfwKJnwa5uYL3tnClvG02MpcQc1Q/cD8TY4r2LhYrKZQMECe+IlzIB7UpjpPDesc+ddzgAYwGxZq4iTydEqOjJfGLf0bLSgct5nUFdfWtEh7oG4t/dNnxzU8rM9W9n4ETad+uA9aO7VobUMi1zywPiQzj5hyjoARi1CNHH15o/sudXS4/SNaFkwAQwlVT8L65j6jh+hF0XBVPLFi4w6ko0XMv/Pd8SF+9Stkvp8TtpMx5ueIjuIEEcF/fZVi07r056o6sw4snA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+1x/G3eRNcveBu0JqAXdmKan6/3bUf7JLuQlYWPAeKg=;
 b=tfVxbGAHOXZh8QxxvMktibP+JEC88WEO2aAdnDseApHiz+rXQkayL9W1yas50+nuVoKyMpGzFr/JfojGyqzSu6CslYZiymgF4z1jmSg+wWNLgtuUIFFv9JN4/uAB4aIdRR9CEOsY3R2mYGmrisKebmgbqdQDsa98jpmS5XAmTgg=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2869.namprd10.prod.outlook.com (2603:10b6:a03:85::17)
 by SJ0PR10MB5533.namprd10.prod.outlook.com (2603:10b6:a03:3f7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Mon, 25 Oct
 2021 15:21:28 +0000
Received: from BYAPR10MB2869.namprd10.prod.outlook.com
 ([fe80::f864:7fb0:2c2d:6d72]) by BYAPR10MB2869.namprd10.prod.outlook.com
 ([fe80::f864:7fb0:2c2d:6d72%7]) with mapi id 15.20.4628.020; Mon, 25 Oct 2021
 15:21:28 +0000
Date:   Mon, 25 Oct 2021 08:21:22 -0700
From:   Elena <elena.ufimtseva@oracle.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, mst@redhat.com,
        john.g.johnson@oracle.com, dinechin@redhat.com, cohuck@redhat.com,
        jasowang@redhat.com, felipe@nutanix.com, jag.raman@oracle.com,
        eafanasova@gmail.com
Subject: Re: MMIO/PIO dispatch file descriptors (ioregionfd) design discussion
Message-ID: <20211025152122.GA25901@nuker>
References: <88ca79d2e378dcbfb3988b562ad2c16c4f929ac7.camel@gmail.com>
 <YWUeZVnTVI7M/Psr@heatpipe>
 <YXamUDa5j9uEALYr@stefanha-x1.localdomain>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXamUDa5j9uEALYr@stefanha-x1.localdomain>
X-ClientProxiedBy: MWHPR21CA0055.namprd21.prod.outlook.com
 (2603:10b6:300:db::17) To BYAPR10MB2869.namprd10.prod.outlook.com
 (2603:10b6:a03:85::17)
MIME-Version: 1.0
Received: from nuker (47.39.6.146) by MWHPR21CA0055.namprd21.prod.outlook.com (2603:10b6:300:db::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.2 via Frontend Transport; Mon, 25 Oct 2021 15:21:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 096347a3-47eb-47de-1781-08d997cb1d94
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5533:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB55330B949B01643678FCFBB48C839@SJ0PR10MB5533.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qlb6yvDfO0XLn/JAl08sQl9/RS2ycavQXyH1p6ySoyPXzQ1EdB37W2JMG95WB9zKrnfJsm4zO2vFlcuibMG1jQ0pNPcW6Dt23UyObh/2yKw0UtT/hgMTfq83/sCjdM0F/lpFFmiemMWHVeAdBIZT7E3rr0Vjb4dBB9KoIyZbGN7o4ByZl6DyZ73h/aB9hTRxn5UBnAT0pUCmvpRU1eqleChVHZt8lBRPMULWQLKjvCntWXb0qJCMd4R2PX+4Sndr6aigGjFT1DGwKGKdGuDIaRQDHwUojie5Lzsg501b8c8T+6euPPaaKzv7wQeI4ST5Jdze4ShbyjdAFwFgf6hMAiMhmOScy22naqfvkN8F4UKhxIK+1apGD/5cOJ0Ppz0pQf3CUquDS5AtJ4qS7mLi5sD86g2RNywYXwRqIQa+eI/jv37yXeG7KqfPpnHC+libactpL0ZNE9enaP2zJP27/7UhysVHdA/Bq2+iWSwc+mjZfMVYn2H32RMKAiZh4ziM0ZVmN8yGYhKecvTgtdwsh5YHLdTO7CkerBF+xXayNdjBEYOJHdSQLVYHUq5ADnp1R1420AIw02L/fUUYfBsPamUWBlIfp8DCiml/SZPktZwRE116NjueOakxyntZHp4Qx2OVs9a1u632pCHZ+nsatoOvuyrrO7UgrD1zN1f1RxkYDvTKYIiRkLiN0sPgbO4cO4YdhbA68YymurrgJtofxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2869.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(5660300002)(316002)(6916009)(83380400001)(86362001)(8676002)(8936002)(9576002)(6496006)(52116002)(1076003)(6666004)(508600001)(66476007)(66556008)(66946007)(33716001)(956004)(38100700002)(9686003)(26005)(186003)(33656002)(55016002)(38350700002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IJV8ovpgeEInISCIQcVcX4zIrqdh3tPWyxj7Tc1Ls9W2l8SPS79ds7UHIM4s?=
 =?us-ascii?Q?cI/5pYtqXeInyIFS3YXesNsMlOZzqGJNSccK8ZlQrJ9Qo4BiX6VgigPy+44J?=
 =?us-ascii?Q?5jzfh51FllPAwVAql5opR043cr8YzirhC+HN7FBrCA0ZSy+B/1T3rpFgUqUx?=
 =?us-ascii?Q?hJvcSUbSSDgfrgzpsMBP8+FHGPEvnVDFmGZOPYF/WjT+qNxP1h7GgEimV4Tv?=
 =?us-ascii?Q?BFt2AmOxn/hylCUcsEv3WvnTtp8sxstzwDRzyyMMxBuGAg0LnhQ5gaMN8Qc0?=
 =?us-ascii?Q?kkZ/WI30PAuuoOlUkIAw5QtOrHfFRoTrJpcOwtKQBMreIO6oqsjYYsLCSVUo?=
 =?us-ascii?Q?DBrLSPrq/tvntHFWyp4KTXklHUp+som4b+6et5FUqKF9SCuKMMGB1YsWXngG?=
 =?us-ascii?Q?oxbACa+i2g/vzXOPMW7EFRsi0iID01dPZikzmhUpV2ihSWuNc0F2t1AUTkE6?=
 =?us-ascii?Q?59aBEDIhYcnWSUy6cNmW1qwKGC8HX1eA2qcEPR6+BOC7UbNCaNniuSnq7Qz2?=
 =?us-ascii?Q?p2qW9JnOW22BH1twHzthkA/rS1ftGkHO1ooune9Vxay5maLkSwKfBLAtEq8v?=
 =?us-ascii?Q?xrHMJlcvR8Tg8cZ6enCg0gY14kQazXvc+6J6ywARl8mxROCazxIjvqBRPfBT?=
 =?us-ascii?Q?KxbK5GzKOEOHnpWL4YfHht7OINvdRxx+p4rJhtuR+74qMsgKQyO7TXklp//d?=
 =?us-ascii?Q?zriQ8thgo0eN9cCpDxGgNVIgdCgJxg6jL8vJmM8ycE4G/BOHoEcABVUREJRD?=
 =?us-ascii?Q?pcxkRx/e9QGH30oX4pRHkWPbD3RB4p6iJv1NrS6+JuzjFGOjmw4ezZ8Z1Zm/?=
 =?us-ascii?Q?eGCe3diO17N/EXNGgRzkZAepi0oxCKYWzxvivRjbAw/6Ci4tWD1kuOTgX5Kc?=
 =?us-ascii?Q?jwX8KnSvLarX6rysIKVDAvAe9BUtIf+H1Yu5xb0oeht6TQc21+T/jBdu3zdE?=
 =?us-ascii?Q?Bdus7fz9j0E3et4Rz3MR7E+75ZhQA/2kC1WN5fgcamqZnFEukDJQAO9bDtgO?=
 =?us-ascii?Q?Ifu4CM47GcDcgJT0h7qaKfg+CU2xwEaUGzmXCSi4ySCFt3UTuYkU4/QReRjZ?=
 =?us-ascii?Q?hSovEqpRaVvqpHovJaEWxcnBg44RnjiVK530Smf2LVaZFUVcYcazFhnmumVh?=
 =?us-ascii?Q?ZX3HXUn9ZbepzzDlk8lIOm1UNbt3PV7kgq7q59stYP4R+0WdgztyzCC+8U5G?=
 =?us-ascii?Q?Q+7I5+ZQKtZkVeqx43Mhm0KZwxSWOD820AWWNmlM+6+NEf2xbSqHpfp0N2VC?=
 =?us-ascii?Q?mgJy3MwA8wZolbrW0ZUMnALl0htTWXZwUuDLqGMdkduBB4lrSt4dbSUz0THH?=
 =?us-ascii?Q?MDUZO3kDUfuFy63Bza137TufpG6XxachW6gN1+I2LNQN2uBXqDRS9FNkOoDM?=
 =?us-ascii?Q?JaoXcHMj4btmX4VIIfTEfawOK8QsJZCWxLCP6KJOc57YXTcNjb+ZZhZbOOTT?=
 =?us-ascii?Q?CSrToxMjQsm/dw8sj7O6OEdxI/K68Nz/zllTDlcONos88i0jErGybGb4fAR4?=
 =?us-ascii?Q?L3yfwNS632y7MqevRjLDO+NlbqpIe/RE9UY/1XY7/1kSyH4h6hAfPUH2M6Il?=
 =?us-ascii?Q?3skMPrAansvVn3DZpNMjkR/GuEHxaysBFTbTxp3wM+oIG0Y/CyzrKS8yq0fD?=
 =?us-ascii?Q?7CuK9O2/2fRoV8xGsen3nuDqjKXzqYdrwRqCJ0ox4KEDOaXEA38jsKc6++0G?=
 =?us-ascii?Q?OHXJPg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 096347a3-47eb-47de-1781-08d997cb1d94
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2869.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2021 15:21:28.3213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ycTSMOX/WpMx3VFCVy/LDJEpPjk18bJTxV7si8PgiEcD21JtdrqfvE3ujpmWSh2VK+jRRVh7OSWXjgWry1VEfw+2WqZ2vK4PMhPdcWTzGww=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5533
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10148 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110250092
X-Proofpoint-GUID: zewW3zWF1gre3_dVfWgJrKemxnwkLP6W
X-Proofpoint-ORIG-GUID: zewW3zWF1gre3_dVfWgJrKemxnwkLP6W
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 25, 2021 at 01:42:56PM +0100, Stefan Hajnoczi wrote:
> On Mon, Oct 11, 2021 at 10:34:29PM -0700, elena wrote:
> > On Wed, Nov 25, 2020 at 12:44:07PM -0800, Elena Afanasova wrote:
> > > Hello,
> > >
> > 
> > Hi
> > 
> > Sorry for top-posting, just wanted to provide a quik update.
> > We are currently working on the support for ioregionfd in Qemu and will
> > be posting the patches soon. Plus the KVM patches will be posted based
> > of the RFC v3 with some fixes if there are no objections from Elena's side
> > who originally posted KVM RFC patchset.
> 
> Hi Elena,

Hello Stefan.

> I'm curious what approach you want to propose for QEMU integration. A
> while back I thought about the QEMU API. It's possible to implement it
> along the lines of the memory_region_add_eventfd() API where each
> ioregionfd is explicitly added by device emulation code. An advantage of
> this approach is that a MemoryRegion can have multiple ioregionfds, but
> I'm not sure if that is a useful feature.
>

This is the approach that is currently in the works. Agree, I dont see
much of the application here at this point to have multiple ioregions
per MemoryRegion.
I added Memory API/eventfd approach to the vfio-user as well to try
things out.

> An alternative is to cover the entire MemoryRegion with one ioregionfd.
> That way the device emulation code can use ioregionfd without much fuss
> since there is a 1:1 mapping between MemoryRegions, which are already
> there in existing devices. There is no need to think deeply about which
> ioregionfds to create for a device.
>
> A new API called memory_region_set_aio_context(MemoryRegion *mr,
> AioContext *ctx) would cause ioregionfd (or a userspace fallback for
> non-KVM cases) to execute the MemoryRegion->read/write() accessors from
> the given AioContext. The details of ioregionfd are hidden behind the
> memory_region_set_aio_context() API, so the device emulation code
> doesn't need to know the capabilities of ioregionfd.

> 
> The second approach seems promising if we want more devices to use
> ioregionfd inside QEMU because it requires less ioregionfd-specific
> code.
> 
I like this approach as well.
As you have mentioned, the device emulation code with first approach
does have to how to handle the region accesses. The second approach will
make things more transparent. Let me see how can I modify what there is
there now and may ask further questions.

Thank you for your input Stefan.
Elena

> Stefan


