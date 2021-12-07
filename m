Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E91146B067
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 03:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235417AbhLGCGi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 21:06:38 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:55244 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229727AbhLGCGg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Dec 2021 21:06:36 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B6M5S94016355;
        Tue, 7 Dec 2021 02:03:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=JUNwvV0KVMpgjAPLiH/3EGSbzewRI14DtbJrQhQ+Pz0=;
 b=BI8QBW5Zx7NnpMst94Ah+bYqPp/PmDSgPM1xlelo9KcaWdoMfSzgu+xPQAp4QBm6q5Q3
 tHpp5Sb0EfBgw6TVqbmX7XfK52l2MDtzGNPXjRKwVdK/ssvVlAgfSoVry9RfmsWDkwyO
 mJ7/5RPjG0DuUVh3o+WnXP1RDSnoP7Od4un6QVwHbcxSGe49uG8c1J8yDOVVhsKAUCDx
 xhvdH0+Mdawx5FnKCXXsnY2nw7l+aAqZVliplC7S58MZgJ1ONhP2DGbZHUrsQ0K8xv5/
 AaqXbYgFB81PRIAlVz6Ip8UBCWU9PMGjLSVAdQgTX4TxLsFRz3gpeyuUSTYUh9ZOxC8O Vw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3csctwm1rp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 02:03:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B7228It035250;
        Tue, 7 Dec 2021 02:03:03 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by aserp3020.oracle.com with ESMTP id 3cr0548n4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 02:03:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fYVeJh5Cf6/Jpi7GhjkWi6KkdoBWUPtTmsFHkFH09ic+h/rmREFesa3Yskc+A+3LtlP3BFt75MIglIBkaGyRqmwj5dVZ+5y4zGLdKBw5pnmT0pD8/orbSGAeth1CtGo0Vxr88N/UHQJNIde0lVjxKrqi6sFYG/yvccqNduQoAeYPmGZpox0VI6ebbNQcgjZ3AlUx/5l5Ub8B2VpVqddcjeWmODqRGP++1I5LhDEuoxBHDaDFUQtX6hNMBGJXRW9bGL8fP3rm57F29wDYK6aPVAxxNlxNcIwnLdbWv1yEz3QQRNmwu96wLd/LfCPyBNFiwgJ/G71p2vw6bGnete+4Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JUNwvV0KVMpgjAPLiH/3EGSbzewRI14DtbJrQhQ+Pz0=;
 b=eFV++wVGtea0M825KfJLHprfuIY/hUpeLg1OYwrZq/Z3yjzAbcDFCNGl4ptAivEM5cYwcivkg7dRdPbaakWwo4IHLFkdF5BCVf7MlOJ4p07FniNF9Vmdenqoofwd/pCI+Ow188MRkBDFH5ASh+IriCXR+G2R8K3Doa4plGqVFjYu50QD6rzdd2csBd5MNteUHY/dQVvPvkzpVaRfZzB9lIuQrapKGvCfmJzrrz9hW2om6HrB4Wkx6vySEUUc1KvPFU26QBAfs1FUYPuh0dO3X2qIsKMVTMBQWFe2vkK4CTybdO+EeHaUnv4CAzfipvUPpPeU2S2ytr32l73mhdb/fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JUNwvV0KVMpgjAPLiH/3EGSbzewRI14DtbJrQhQ+Pz0=;
 b=FTkkqxEJX8WDZdfTD8MQmBzTpSF7pH7Yz2tVMKXzfV6MV1BqCfOAiHdKVff4FyqwstwxBmpfkqnl+ubT4q3/KSkiGNlv0mjX29WVv1fHl7r9fwqBdBvFbkFHgyMneG8VSPpYpQf5T6gH32gUdVZRysCBfJC15TkAZEFnQF4fHig=
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA1PR10MB5709.namprd10.prod.outlook.com (2603:10b6:806:23e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Tue, 7 Dec
 2021 02:03:02 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::d948:18c7:56ee:afca]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::d948:18c7:56ee:afca%2]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 02:03:02 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 0/2] KVM: nSVM: Test MBZ bits in nested CR3 (nCR3)
Date:   Mon,  6 Dec 2021 20:07:59 -0500
Message-Id: <20211207010801.79955-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0024.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::37) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BYAPR07CA0024.namprd07.prod.outlook.com (2603:10b6:a02:bc::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16 via Frontend Transport; Tue, 7 Dec 2021 02:03:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50df85a0-40c1-4888-feb9-08d9b925b313
X-MS-TrafficTypeDiagnostic: SA1PR10MB5709:EE_
X-Microsoft-Antispam-PRVS: <SA1PR10MB570992E73E8F0AC992064A5F816E9@SA1PR10MB5709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GMuDK5CKqkzy1QFeFG1fsBGkkNZgLI/iyPKj/MV6KA6RWGWu4KoSaJLcr3LmOHQBLyLJwyJUHIJffNWDtWfLCKl7UwOg4cY9+Zwywk7+A9ItHIozplNuqjPHnu2SGGelKNXTWQ9v5giw9mxmE9W0BFmgZFug+ZHotjbgiQOAqMcbJn8j6qxqsjv7tYBWMqi+TT/vC1GA+xpLYzNPBvFfCduefQbs528WuyupC5NoiB29EFZF4mEJphDgZSJci4JA7dK6XvhAawy3maEitjrOIZqma8H5eZVEzWE8Nqr4Xj2zXdF/wLDgeKthxOn6InbeCjVLNC1Wj6MX4zaEpKsHsVLB7imbMxtCgBIcT1QHEwvYciSyzoqDq9pSSW/1nOjjROFWBJzXu3swgRa3BFNVP49erBEAvRwDlZNeMR7qBIOlYKcTV7L9TqALTmGhNq8ZCWaBtu0MSRploBFkyTDlG8PYfKjO58U21LGB6TPIL/c6Ls/MqQ6sBmm/GYgMj4kJASMMWPPA0lNYM/7Uh4mizfOLvDt2wVykH9RwDhRFljyE2ODEWow5YvfJyj9uMw/4wHHgEVwOvkN+OMnqDXntnQx0War8aW9y7GmnE3uqXxiDKz0Lur5h+CnjaAi6kNdHiPh2MAF1dhXs33H7BeqIhl7tRAzkWedixLEeGFZuQukObhqzXhWd3Y/hHiInrgMb6f8gDP4ZOk3f4JuwkiYDzA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(4744005)(8936002)(5660300002)(86362001)(66556008)(186003)(4326008)(6486002)(8676002)(38100700002)(1076003)(38350700002)(26005)(508600001)(66946007)(316002)(52116002)(2906002)(6916009)(7696005)(83380400001)(44832011)(2616005)(956004)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?geiP8B3O9n3vRFioK1ypnPebnXzvXv2qSQCZ1SxuoBrqN4+daOrs21yirrV6?=
 =?us-ascii?Q?7SyGXD6FXQ+3dIlbKv2emzexdGrWogxUijiqth8r76eQdWpp1Mn8kr0E21zX?=
 =?us-ascii?Q?T6fJF0a06mO7TeBYJh4klAaPda6+P+q0z0kXYwNGV3n0rNf7LLIgClNDYRBN?=
 =?us-ascii?Q?xhGBvvc3d3kZfOuarcBVOydjcdWCNXUjX/pAJNY25fHGRqbR6elyVBg5JpjA?=
 =?us-ascii?Q?XRUUtFKKNmQfyQss5XX/Uf6BuqXI4To3ieLQ7pGOZaLKfo9fSwGBgLiOCWB6?=
 =?us-ascii?Q?O73izbQFUQsG0j6VTMY2R8arfFyiQdfmH5y20SC3BAkAN1fFowJuvmeiqeRD?=
 =?us-ascii?Q?rUt5a+ySoTVx3dZFz+8J6DiNrBxBIQb2Io6HJv9GHqMSvPQdRuWR3AZcpArX?=
 =?us-ascii?Q?KerEX6+5SU8NsNZ2dGGSu0vZzxvyVUIhXJZstplQvOTL+dLaVPm4KICVZp0K?=
 =?us-ascii?Q?ALUtQQApNb70fJIDvvweg9HfUgqa6dHcNOafBZGjX2LFSqYoq9dTjStRRZwN?=
 =?us-ascii?Q?Ba8laQQGjQPN9la+/2B49ZrOLaKJT0wACXhFybWt5Ezh3Lo3k0GDr1H56kjI?=
 =?us-ascii?Q?pz2un52hY2DXjf8BvQzGnNh7BbkKrUJmzZS/9NnQtGxgbZ+5V8WYYj+smGsG?=
 =?us-ascii?Q?x2fTUDd3zsfwpDd7hxpCO+HvLBeJaJoETLCbLU+ZAjYcRGG3gB0hi/qmkLxg?=
 =?us-ascii?Q?RDmaeM0zknE6HxG4tiXxfPqp0Xql+uXj7BGJDbzdmt4nkr0mF397nHH0Ap0F?=
 =?us-ascii?Q?GCiObf3fZBLiNCmfgpf7aVPAFyrqVRNNH2qlgyV0IYkktnQ9iWRZ+mMlBWLx?=
 =?us-ascii?Q?mI6OCujjhPn6Jj+DPhO4SYQVYKANsC4z1isiQaRxEKPXs769MSbXT4Otrv4W?=
 =?us-ascii?Q?X3njjxZ80mfOCita2RzUq/DMyfYvgyK3aKnUz4be3HZiLqORfmITcdYnPcA3?=
 =?us-ascii?Q?s3Kpm8XWmQmxjpSBxc3Z+YuPM3lkFAYpqT3+Qjid6GTDLLczQ/d+jvEhDxJG?=
 =?us-ascii?Q?HxiDSt/8O7yfDQnTbgMxAVxW7tFPAcg5hTzu6nhVukBd1DsXMq2dxvz3wuEL?=
 =?us-ascii?Q?BvCgzyWy8oAuoeb7imJC6wA+N72EWsgGvON6RHB6/jvu3/ANLVrZw2XwjQYB?=
 =?us-ascii?Q?NfNWOZxxb3nJfFWgXZWA9UfuIuOCVOk2E59uI1qc+KwmQn0OqQy+Y3lxa2x5?=
 =?us-ascii?Q?1i4PXylt6jrQHp95+V2ImXjIMMcNz3rLdLwF2fWqFFDMCK8Z39vILUvdFIs6?=
 =?us-ascii?Q?vBPJOL2lO9Oywc5BORKOnUnt7nBGv+IH00R7R+jJNLGVEcudazxh5++qhOLW?=
 =?us-ascii?Q?uJ9AOypfJkWTFWpc32bX2upXyo3f0azY200XPLvlslQMs6nmcHtZw/koT/Ce?=
 =?us-ascii?Q?ri8sW65BEXWtJKhjiWD3FDbMGwilLOGvglBrEgjJnicqBw1Im1h1avxWEWEk?=
 =?us-ascii?Q?AO/q9uQZLIVvTxdjVposFA8twY/NmTNK6YHevt9JufICy2Skqw/RMfVs52Ip?=
 =?us-ascii?Q?R5ee0hlAMQyFa3JgqS6jTeUZS2Oz5QgX1HthyXF50uQKH+XpqXDVnJ41MYnG?=
 =?us-ascii?Q?S/mUKQkxjZGCG1AsJnj+GBH/EZ2vVNe1g307ZLcfXNhlw/Y4cSdwtVR6eR4M?=
 =?us-ascii?Q?HvWmjIBKXQkQniG2fwPAyxzPEKB9itCE2OjNOchP395Kqh1ycCJ63l+K1AjY?=
 =?us-ascii?Q?2EBDEw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50df85a0-40c1-4888-feb9-08d9b925b313
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 02:03:02.1425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a8QnPVeqFbqg7BvLHKfn38y1Nr14AoyUVEjkl89nqxHs0uVOWNEYSC+azDU45f/NbT2fVFUHxHFbPCYm2I4ByuaZbvTKDcmytEgpUIE3dus=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5709
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10190 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=699 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112070012
X-Proofpoint-ORIG-GUID: N4ytyJeUoGaA1Cz_xdczzqhDfZN1exUq
X-Proofpoint-GUID: N4ytyJeUoGaA1Cz_xdczzqhDfZN1exUq
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Nested Paging and VMRUN/#VMEXIT" in APM vol 2, the
following guest state is illegal:
    
     "Any MBZ bit of nCR3 is set"

[PATCH 1/2] KVM: nSVM: Test MBZ bits in nested CR3 (nCR3)
[PATCH kvm-unit-tests 2/2] nSVM: Test MBZ bits in nested CR3 (nCR3)

 arch/x86/include/asm/svm.h | 3 +++
 arch/x86/kvm/svm/nested.c  | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

Krish Sadhukhan (1):
      nSVM: Test MBZ bits in nested CR3 (nCR3)

 x86/svm_tests.c | 41 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

Krish Sadhukhan (1):
      nSVM: Test MBZ bits in nested CR3 (nCR3)


