Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CACB14350DF
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 19:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhJTRFu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 13:05:50 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:15890 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230329AbhJTRFr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 13:05:47 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19KG7wK6020970;
        Wed, 20 Oct 2021 17:03:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=BB9nGKEjUSLsvEC43d4DbQp2gyLNBIAxEBbrIgW1j8E=;
 b=U0NdkcvQEwlC7v4F6tBrQzG2jjft/CEadg/T7TPxOgQOxX1Ab0V4XVoDNwMti05rYXBX
 Sak8obkiJXs5Bz8h8wd7Cg/wMsC4QAgeLVTX+YaJaTS/OG44sCjznOmXbzxXcBz1vgd7
 9e5D/EifJZmta/Gjl2jvCtCFKwq2pfyZR69jWVg8eeJUZqenVwuKKqlCgZG2beTlTHfK
 qhOneuiGIO+7vbbnWCsQ+20TNXpjKR91Bw1w/XHULEPrRTmcPHI97DXDXKQne6H624QM
 RzpgObzqUfpWtzPLJ4UoQlJ6ATCTnZAX8RvAzBlwUoRiQ7qG+Pyq4gxoZwgo5387800e 8w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btkx9sf85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 17:03:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19KGtgAa159425;
        Wed, 20 Oct 2021 17:03:11 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by userp3030.oracle.com with ESMTP id 3bqkv0cm8b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 17:03:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KiAUXVyfPkrBMAith9LTirylqLO/PXoSTuubX+L8GWZvdvh7IQrNdejpxQzuL8DiwXmUKy7rTnsxNr/FrapEpWin2jl58lWo2kNyiXBPPM72URBQa1Et1T/iXkygR6OntPnAJqq0RcoQCCpapenW1n8Z+7vaQTgqt5xlqSyFV+Npcrgo+eiHIwSJhQ2n8rIuBuyJvxNe/A+A3COy2sMinRbWphTSRp9PgOaEdq+T+Z1DI+BD4QqrN6kjgVgev6de+jpW+4tpFYnuYg7OjFXae1dMe8r3axEoWWPNTfEWFfnq6pb2QCUaVzDprqNbUmIqJDMh471WPPs+evfbtxesMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BB9nGKEjUSLsvEC43d4DbQp2gyLNBIAxEBbrIgW1j8E=;
 b=DibHD4ojV2Gm9deFuT8zK7DS6VgjpKzEXsUOofXKj6iBk1DsOyVeKo7nzg58MALoKU/qbUp1tgQqUsrIf5es4CAd4fdQYQNsPCDf5T/809IXMA77bNSC7HABOwKj7I3SSfTrb3BawbErVwkVYSrFp5Dko677kCjD41TF+HTEBUkkc7GeqdVDcMnUJ/sQnCZf8z+08kum3pYEo0z/0iv4JgW6gfHez1atN9TIbIutyqMsJuDiPhpZaUyj5PCqLyt63rTlAQVVQhbDboXqNGEZbaG+K3hzFLACkMWPDMfCkSbTOv2AbxVu+e20wjrE/uCrZ/2cj+f1uiNsLB4qULmwrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BB9nGKEjUSLsvEC43d4DbQp2gyLNBIAxEBbrIgW1j8E=;
 b=CSGRhJ6w7tWhhfx3lyHJYSOnksS4zfVqdKjnCFC0xp4i43ObQ40V7MfkbE8mU1vQS6OfwiyOxPOQLmfAuWr2lxMY4nDLTg5/x0K83uKjgb14NwPiNVl8CgAL2wYikK7Jxke33DPQE4DR5Kx57H5Tir1cXoSUK1rcMJ9Qkj9LUDo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (10.242.164.110) by
 CO6PR10MB5571.namprd10.prod.outlook.com (20.181.96.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.16; Wed, 20 Oct 2021 17:03:08 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3197:6d1:6a9a:cc3d]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3197:6d1:6a9a:cc3d%4]) with mapi id 15.20.4628.016; Wed, 20 Oct 2021
 17:03:08 +0000
From:   Ankur Arora <ankur.a.arora@oracle.com>
To:     linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc:     mingo@kernel.org, bp@alien8.de, luto@kernel.org,
        akpm@linux-foundation.org, mike.kravetz@oracle.com,
        jon.grimm@amd.com, kvm@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, Ankur Arora <ankur.a.arora@oracle.com>
Subject: [PATCH v2 00/14] Use uncached stores while clearing huge pages
Date:   Wed, 20 Oct 2021 10:02:51 -0700
Message-Id: <20211020170305.376118-1-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.29.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CO2PR04CA0176.namprd04.prod.outlook.com
 (2603:10b6:104:4::30) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
Received: from localhost (148.87.23.11) by CO2PR04CA0176.namprd04.prod.outlook.com (2603:10b6:104:4::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Wed, 20 Oct 2021 17:03:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c057bdd-6d01-4324-b3f7-08d993eb7d9d
X-MS-TrafficTypeDiagnostic: CO6PR10MB5571:
X-Microsoft-Antispam-PRVS: <CO6PR10MB5571E29B0A17AD7B8066738DCEBE9@CO6PR10MB5571.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?8+6yvO8tru4UaCjdLzUzus8xE4VYhAXJvQLb6BMI4QYAcRRFdFvv4tJDcxcl?=
 =?us-ascii?Q?2hl7nMJpb74uw8j7rFnDFm0e4C7LspnYrhM34R4GMFHVqkqs7fAwgT0GUAgF?=
 =?us-ascii?Q?IMrDtZ87GnCGfMB7VjGIt9tVL4ll59aoXpt0UjxzINTc7e7w0erAfblLpxKo?=
 =?us-ascii?Q?1cSa42tuJyjQMBq81QO5CPC4qu0bYaRznN60XYDXbtstpgi7U5rj/DuSOfLY?=
 =?us-ascii?Q?k0tzafEb9/JaqglbrRAnJbggvTNTZs8k5paWQ+qmKveQ/d9AGd+hSuxzmAwb?=
 =?us-ascii?Q?S1twkBn/+83hpgOd0bjX+KW5UV+3npWMSX/VUTpxppSFZd4TCZrL2/pTWXFF?=
 =?us-ascii?Q?fyqS9T7t255t3YaFZin0ywH+qX+5DJTgoeaqSbk1I1uxi2KuGp2PqqoJoD+M?=
 =?us-ascii?Q?G2+9jgmpXl4a+cPRrFpQphPB5FdOyWOiRASRYwzIAtAG4jDfQ3+qsOXlzN0p?=
 =?us-ascii?Q?6wdBvQUveFFmk7ZFJjkyMlijkOlX2JXio28m/rLBxp2jyHGoNgZOb7+DW67l?=
 =?us-ascii?Q?FrlZ0egp2HITvadhEdWgzeJ/4G62Yc9MyZCqv8D2DzB+mGLXZdSqUzKL5c54?=
 =?us-ascii?Q?r6z5Wmx5XUsJ1TazPsZTk7aoMYsXFllBdXAdT1pzmNTi1p5f9fI924bAf3oQ?=
 =?us-ascii?Q?RWtxqUdMv3v2iVXqAGKJn0cCCU67q3Pw0OVHKWlKCD9+wONxRiQDQKyPQZbw?=
 =?us-ascii?Q?YJBmbb0EfGwgSifIKNAqKzDOM9M6A9D1Onh0Htne8VqxRs5Ad8oWBynfdQ58?=
 =?us-ascii?Q?kquoJBQkIlZoHPKkt+qKt1WR333yNln1UHEj6ZCN0kHhDphYaO2DBML3c0Zn?=
 =?us-ascii?Q?fL2Y7W1pFuHY3Xlib4/KROrmsnRl52YhNA40JYy/c73h8TKoUya0n3VHjGbL?=
 =?us-ascii?Q?n4oeVGgET05f4IJ6Lwi9rni7dIOYeGFhdMUrcQ+v0rVjrP1+eFNNhZq1TE6n?=
 =?us-ascii?Q?mVKsLFyk8qsjVTuAqqpg125Ry8KsH0aR0wfxOCMNDLHzMnXSL5GndIvghEBK?=
 =?us-ascii?Q?1pse9XoKlzAdFcb34nrtL2M6lO4p5tj2ccSZah93QE3pnxyzYOQFPBO5DFdo?=
 =?us-ascii?Q?1TyHeZWFhAOYJJpYQFyOimQfHQWvJ6LY9I0Mxb+8yeoxHpnlZ3yDOcA4jjp0?=
 =?us-ascii?Q?ZfV+LgYCHIiFIIjVRWdGD+6Bf4decafKUYlUWoPngt1v8IIIod3G26k=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:OSPM;SFS:(366004)(8676002)(2906002)(66476007)(6486002)(103116003)(66556008)(83380400001)(1076003)(956004)(107886003)(4326008)(8936002)(5660300002)(2616005)(36756003)(6496006)(52116002)(86362001)(316002)(6666004)(186003)(38100700002)(38350700002)(26005)(508600001)(66946007)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YZa7bZ5iOyx9W62mVnBdjwDMBdrGeTAKJ+mKmcsVMoePoBpttJpMCtVvDtBm?=
 =?us-ascii?Q?UBaA3HGAnVcC87D6SoR1DB9bSP1T8vE7ru110TCb/NmZYpNGFukQ/oM5uhLe?=
 =?us-ascii?Q?MDPnfCe4UdMcPtnr0avm9XHMginLy13j7tkVr72YXtSO+q0PmiujR/cRC8iR?=
 =?us-ascii?Q?erGwO4xTLnP8BIC/A7keOeAisZh7SKK+P8WRc7QD3Q5tH5tvAXuHxVso+NRh?=
 =?us-ascii?Q?0zqZM0OC3XbG9mTZVUoY9RgjY0QZcyaDoA3HD3Sk8uRxTpFUe8ItMWsEjjiY?=
 =?us-ascii?Q?paganGXjEWzwPmmE+7AkNCgBe1yxJ//OO7tWwJkOnKU07s4C/mwb6+QuxduS?=
 =?us-ascii?Q?3m95l/QliDaiDGpmRfaSrvX+s8kBygGzVgFKAKeZ1+DfHl/0HeWsU0KV+2oI?=
 =?us-ascii?Q?uSatmP1WcaXelrOIS2hce/Lt6qMSsV2GMDDpd9HfETd/prprcnvAeBlWc5Ki?=
 =?us-ascii?Q?tGZWojNObO4W08HCbnt4uydCp8AsALo+LUp2bZ6XUdxZfZm58gGB+zKZpnr5?=
 =?us-ascii?Q?wOx1yv4Xq7Zg0GvmghIGi8pGvoYOOc/3hZJZqc5ya9/ZVuJbt36f1UjYafLR?=
 =?us-ascii?Q?3DaxbPUt9CyU7eE1Y/99HEDr7TGytOMiUfnye3Lxr8fJ8Dyes9SQU3VhKFvV?=
 =?us-ascii?Q?RWjtsQWwFXBfeWtkn+TYi1ad/iYx9pUH1IxaVMuel2YLhBsxDt7U3XapeI/S?=
 =?us-ascii?Q?YwoAA+m+WLc8JfGaeYbhPCDbDo4rd2alF8k/PF5KcsPIkAf6Gvn5CNvmynwl?=
 =?us-ascii?Q?J7ii4UeR9aAdNh7Ez8NvJ31UbwyqECxPPmJZSQZ9SFD6wTWlqrcLTWwH7w/8?=
 =?us-ascii?Q?h1/r1rUuEeOMF0qpFcSPrTasUXBb3S7w6ryW7IaHkkE8kDhH0QNCCjC+oTSN?=
 =?us-ascii?Q?XCm7FZeSPAPaqHWVWE3643MGONr5K+OEf/fS2kewFFu8b5tsYA0ehsEdm5u4?=
 =?us-ascii?Q?WiE0R9X6D7ZYl5g8mJae4Y+Mzi0YCwMD/8fPJ/jcrwsa5yZLepKujfGGp1ah?=
 =?us-ascii?Q?rYOFVmIsQTCKT9PpoVorHKZe6Zxed3MHEl2Sd+yZYfKXwss5lTTIXgWuVKBi?=
 =?us-ascii?Q?dLQWgVmCwRL5/VyBQiNTa/ugySFmw3PIjRsX1gT0QYu0Ccn5m+0pZmE0ecMN?=
 =?us-ascii?Q?nM6kRIjsE7Fa4zoOdcw/lwQ/I/VnCIj3D6/G5Wadi+x/Wdk/gh3WdqQTVjU1?=
 =?us-ascii?Q?bnAb1JnCaKWVHmsiC09d0O4oI6xwMH7BJMEbMJ7Unm1Fs5qELDRrAxA5CD20?=
 =?us-ascii?Q?qYTnBrYW6Th+ITUUJkqBq+FKmrwQeckwMGE1zzRDQryRdGjXPsRPNdOAhrzu?=
 =?us-ascii?Q?jNCU6PwLKAJC7xVd560KinKarLfV7OtLFl35zK2AxkSK8UusywMy50MtmzrW?=
 =?us-ascii?Q?qqPUH97mVk6d+1G1bsx5SnmXzTuw1F4GyMaVVNPnFAk/e5WQeFU0NtpUES9r?=
 =?us-ascii?Q?Hs2lp4FlRVYBFmQQ3nmo8+vrcAmUC7tZ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c057bdd-6d01-4324-b3f7-08d993eb7d9d
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 17:03:08.6518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ankur.a.arora@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5571
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10143 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110200095
X-Proofpoint-ORIG-GUID: FW1P7QeOQDkEGyp56Kkuw0AreqWrU4oG
X-Proofpoint-GUID: FW1P7QeOQDkEGyp56Kkuw0AreqWrU4oG
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds support for uncached page clearing for huge and
gigantic pages. The motivation is to speedup creation of large
prealloc'd VMs, backed by huge/gigantic pages.

Uncached page clearing helps in two ways:
 - Faster than the cached path for sizes > O(LLC-size)
 - Avoids replacing potentially useful cache-lines with useless
   zeroes

Performance improvements: with this series, VM creation (for VMs
with prealloc'd 2MB backing pages) sees significant runtime
improvements:


 AMD Milan, sz=1550 GB, runs=3   BW           stdev     diff
                                 ----------   ------    --------
 baseline   (clear_page_erms)     8.05 GBps     0.08
 CLZERO   (clear_page_clzero)    29.94 GBps     0.31    +271.92%

 (Creation time for this 1550 GB VM goes from 192.6s to 51.7s.)


 Intel Icelake, sz=200 GB, runs=3  BW       stdev     diff
                                   ----------   ------   ---------
 baseline   (clear_page_erms)      8.25 GBps     0.05
 MOVNT     (clear_page_movnt)     21.55 GBps     0.31    +161.21%

 (Creation time for this 200 GB VM goes from 25.2s to 9.3s.)

Additionally, on the AMD Milan system, a kernel-build test with a
background job doing page-clearing, sees a ~5% improvement in runtime
with uncached clearing vs cached.
A similar test on the Intel Icelake system shows improvement in
cache-miss rates but no overall improvement in runtime.


With the motivation out of the way, the following note describes how
v2 addresses some review comments from v1 (and other sticking points
on series of this nature over the years):

1. Uncached stores (via MOVNT, CLZERO on x86) are weakly ordered with
   respect to the cache hierarchy and unless they are combined with an
   appropriate fence, are unsafe to use.

   Patch 6, "sparse: add address_space __incoherent" adds a new sparse
   address_space: __incoherent.

   Patch 7, "x86/clear_page: add clear_page_uncached()" defines:
     void clear_page_uncached(__incoherent void *)
   and the corresponding flush is exposed as:
     void clear_page_uncached_make_coherent(void)

   This would ensure that an incorrect or missing address_space would
   result in a warning from sparse (and KTP.)

2. Page clearing needs to be ordered before any PTE writes related to
   the cleared extent (before SetPageUptodate().) For the uncached
   path, this means that we need a store fence before the PTE write.

   The cost of the fence is microarchitecture dependent but from my
   measurements, it is noticeable all the way upto around one every
   32KB. This limits us to huge/gigantic pages on x86.

   The logic handling this is in patch 10, "clear_huge_page: use
   uncached path".

3. Uncached stores are generally slower than cached for extents smaller
   than LLC-size, and faster for larger ones.
   
   This means that if you choose the uncached path for too small an
   extent, you would see performance regressions. And, keeping the
   threshold too high means not getting some of the possible speedup.

   Patches 8 and 9, "mm/clear_page: add clear_page_uncached_threshold()",
   "x86/clear_page: add arch_clear_page_uncached_threshold()" setup an
   arch specific threshold. For architectures that don't specify one, a
   default value of 8MB is used.
  
   However, a singe call to clear_huge_pages() or get_/pin_user_pages()
   only sees a small portion of an extent being cleared in each
   iteration. To make sure we choose uncached stores when working with
   large extents, patch 11, "gup: add FOLL_HINT_BULK,
   FAULT_FLAG_UNCACHED", adds a new flag that gup users can use for
   this purpose. This is used in patch 13, "vfio_iommu_type1: specify
   FOLL_HINT_BULK to pin_user_pages()" while pinning process memory
   while attaching passthrough PCIe devices.
  
   The get_user_pages() logic to handle these flags is in patch 12,
   "gup: use uncached path when clearing large regions".

4. Point (3) above (uncached stores are faster for extents larger than
   LLC-sized) is generally true, with a side of Brownian motion thrown
   in. For instance, MOVNTI (for > LLC-size) performs well on Broadwell
   and Ice Lake, but on Skylake -- sandwiched in between the two,
   it does not.

   To deal with this, use Ingo's "trust but verify" suggestion,
   (https://lore.kernel.org/lkml/20201014153127.GB1424414@gmail.com/)
   where we enable MOVNT by default and only disable it on bad
   microarchitectures.
   If the uncached path ends up being a part of the kernel, hopefully
   these regressions would show up early enough in chip testing.

   Patch 5, "x86/cpuid: add X86_FEATURE_MOVNT_SLOW" adds this logic
   and patch 14, "set X86_FEATURE_MOVNT_SLOW for Skylake" disables
   the uncached path for Skylake.

Performance numbers are in patch 12, "gup: use uncached path when
clearing large regions."

Also at:
  github.com/terminus/linux clear-page-uncached.upstream-v2

Please review.

Changelog:

v1: (https://lore.kernel.org/lkml/20201014083300.19077-1-ankur.a.arora@oracle.com/)
 - Make the unsafe nature of clear_page_uncached() more obvious.
 - Invert X86_FEATURE_NT_GOOD to X86_FEATURE_MOVNT_SLOW, so we don't have
   to explicitly enable it for every new model.
 - Add GUP path (and appropriate threshold) to allow the uncached path
   to be used for huge pages
 - Made the code more generic so it's tied to fewer x86 specific assumptions

Thanks
Ankur

Ankur Arora (14):
  x86/asm: add memset_movnti()
  perf bench: add memset_movnti()
  x86/asm: add uncached page clearing
  x86/asm: add clzero based page clearing
  x86/cpuid: add X86_FEATURE_MOVNT_SLOW
  sparse: add address_space __incoherent
  x86/clear_page: add clear_page_uncached()
  mm/clear_page: add clear_page_uncached_threshold()
  x86/clear_page: add arch_clear_page_uncached_threshold()
  clear_huge_page: use uncached path
  gup: add FOLL_HINT_BULK, FAULT_FLAG_UNCACHED
  gup: use uncached path when clearing large regions
  vfio_iommu_type1: specify FOLL_HINT_BULK to pin_user_pages()
  x86/cpu/intel: set X86_FEATURE_MOVNT_SLOW for Skylake

 arch/x86/include/asm/cacheinfo.h             |  1 +
 arch/x86/include/asm/cpufeatures.h           |  1 +
 arch/x86/include/asm/page.h                  | 10 +++
 arch/x86/include/asm/page_32.h               |  9 +++
 arch/x86/include/asm/page_64.h               | 34 +++++++++
 arch/x86/kernel/cpu/amd.c                    |  2 +
 arch/x86/kernel/cpu/bugs.c                   | 30 ++++++++
 arch/x86/kernel/cpu/cacheinfo.c              | 13 ++++
 arch/x86/kernel/cpu/cpu.h                    |  2 +
 arch/x86/kernel/cpu/intel.c                  |  1 +
 arch/x86/kernel/setup.c                      |  6 ++
 arch/x86/lib/clear_page_64.S                 | 45 ++++++++++++
 arch/x86/lib/memset_64.S                     | 68 ++++++++++--------
 drivers/vfio/vfio_iommu_type1.c              |  3 +
 fs/hugetlbfs/inode.c                         |  7 +-
 include/linux/compiler_types.h               |  2 +
 include/linux/mm.h                           | 38 +++++++++-
 mm/gup.c                                     | 20 ++++++
 mm/huge_memory.c                             |  3 +-
 mm/hugetlb.c                                 | 10 ++-
 mm/memory.c                                  | 76 ++++++++++++++++++--
 tools/arch/x86/lib/memset_64.S               | 68 ++++++++++--------
 tools/perf/bench/mem-memset-x86-64-asm-def.h |  6 +-
 23 files changed, 386 insertions(+), 69 deletions(-)

-- 
2.29.2

