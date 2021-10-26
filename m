Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D03A43B751
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 18:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237426AbhJZQio (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 12:38:44 -0400
Received: from mx0b-002c1b01.pphosted.com ([148.163.155.12]:26934 "EHLO
        mx0b-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237504AbhJZQim (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Oct 2021 12:38:42 -0400
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19QFdZXY007385;
        Tue, 26 Oct 2021 09:36:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=FgPIbEeAU1VLkrIa4sw62pNZ2mx+s8xg+UTkdP9keno=;
 b=eo5if/fpiXehHVADsuWbh8uPQ5EdCLFklfv88eXEQjQqiqzlcNfhyiQ9GdVO/FvSRDZl
 Bmj1eRsD9JiIxuzPVhmI8w6nfonHfassL0UArG3LcM5ZxqQP1uakDwmBQBOayKzBRrTf
 +vZYdbENtP3xsOLFCjE45wFw+3vP0Xif4qSGdDFrJDRbmF9XntDHGxqN1icygY6lC2qs
 e4qtIAiwBCYQbUasCAdNMEMucWiwsEMfCT3GvgsD5bWzADnyahtXSPBbI2Y9UpJkWbD2
 FQvdxkP+VInkFvnLdFyx2/Vj2dWosjF2RNA4wXCzpYlQNODa+yRmpfyVPWIDP/JyJ24O 3g== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2047.outbound.protection.outlook.com [104.47.56.47])
        by mx0b-002c1b01.pphosted.com with ESMTP id 3bx4dwhvbu-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Oct 2021 09:36:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jnvvcgRMVeYDtRcIWv66V9pXXc64Be5uO5nBwy2KwC6uUvaA8a0KyOs1Xm+pplzQ5B67TqHcpIScTL2iUNK4AO4WYgmHmBYy27rzQDeOmra+KE8dCY/jyLIRQP4gasVZsvHNINT9BK4P2aTnK7pl582+Mj+7LBs+9vz27gi9Gx5c/gNtWt4/vSP7hUMfnlTFWfWteqI/zOiHHtsuAU+UMbYYXxAzrXMSQZ6vsHZkyxGw7JzjkIKqOKtcjyiMZSqvzZhzL/VdQ8rV+j5HgWfAza3SbyavEBzu9kSIa8XdIFd3r1VSu75BeZLM2tx/NMw5cMbZrnVvXrYnK1YuOXP49g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FgPIbEeAU1VLkrIa4sw62pNZ2mx+s8xg+UTkdP9keno=;
 b=OxhquLNH0bxmFQyjrWe8KU6GcGZRmT8ayBMgHDLJYTuO9p/Z1J/WT0gVIknmvDkRkkmEabM+x39c1KZKRAuXzOPsM3/wD+KS1RjarXJQ5SanWmZe6foW7eVphP3mgKF+s/Jup1D60tshlcx185uR/LjbPtOq0BGiWkP+oHFY21x3/STs0h89n4OeCX+6Ib0oLSG3bIsAxoi7XvkYM4m9DynDAFhkkuk06FLQWIHF+suQ48FnzRtMvBbT2cMIKFmC/kNB7cEJaA6Julp5utRseRGssfTjMb2SVWWT7JQM5vFZVIh61x/SotsjuPbW/5N/ALRmuN3i+NOyTKnahhprRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nutanix.com;
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by MW2PR02MB3772.namprd02.prod.outlook.com (2603:10b6:907:3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Tue, 26 Oct
 2021 16:36:04 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8d99:ba07:279:25c3]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8d99:ba07:279:25c3%8]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 16:36:04 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>
Subject: [PATCH 4/6] Increment dirty counter for vmexit due to page write fault.
Date:   Tue, 26 Oct 2021 16:35:09 +0000
Message-Id: <20211026163511.90558-5-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
In-Reply-To: <20211026163511.90558-1-shivam.kumar1@nutanix.com>
References: <20211026163511.90558-1-shivam.kumar1@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0369.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::14) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
Received: from shivam-kumar1.ubvm.nutanix.com (192.146.154.240) by SJ0PR03CA0369.namprd03.prod.outlook.com (2603:10b6:a03:3a1::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Tue, 26 Oct 2021 16:36:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9872bb03-27aa-4b12-faa0-08d9989eb3ca
X-MS-TrafficTypeDiagnostic: MW2PR02MB3772:
X-Microsoft-Antispam-PRVS: <MW2PR02MB3772E7A34DE60F21FA14347DB3849@MW2PR02MB3772.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /BnR2KplWKc3uj5HgpLYaG/loJlT71L2GpOOXbVjIzqX9PT86p2R3evbwye9O2iWVAvwhv8hZszepwIuSRpUXwOt9oNlpmcmSusLOxPka7jkk+KICSoY3d13mR6dy0ld84l7vDbskp1WvAhIazMKQc/kIoVqfJatijETH2pWdYYDmCR3Qb+G41kGBA7C0Yr03LKIjrtGyuT4ByUoZvRrzxdRsdPUT0EysYa+qgJYKSHzF2P7bzlMc5nFnHUQxnuSRx9lLNH143CxImecxpzktYmHn5+FjaufPkB+uuxn2B8QMAE65T2UqfJcEC5vJX/19yYQuVdVmeHJjafaMUQlvZsEzmxKDTn/DztNcQ6mJMKmsNIXuvMal14L/adHKXfdMIXj+GljitWF8hEWXdBafEQMjbd+k5djWkuzsoluOM/newITmmZfSCguiXLMWt6kJuAw5erA08QFbs26DIHkhg9iAob+Z6N0+hb972/KTuRQCI3/fZF8GP7ZFxo2T1VQ9WkSdWI0UrWAajxbm66zYe4ZtmljkPIrj9n++Vxl6SL/tkRroSumx6O1ni7Po2WF9EzgrVuY2PAvF2hRV61dtTp/dvdkjkSjMg9Pvrk8mX9SvP9Lhx9AU0QNoRMcNXYb2p3PZsd0eLX76HvcYPmgX5EgQ43FVLQ2y9pz4umWg207zFxyx5wdKSIZeewRQ92L1nheLMUy2LDsv3MhrcrjC2H9LkH/GRCJ82biV+QBuSI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(4326008)(8676002)(36756003)(66476007)(66556008)(956004)(66946007)(86362001)(2906002)(38350700002)(6486002)(5660300002)(52116002)(7696005)(107886003)(54906003)(1076003)(6916009)(508600001)(2616005)(316002)(38100700002)(8936002)(186003)(83380400001)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yCOPDoWQ9FOed2jM1Wc2qwguApFarkblcLBDBMded/e81BvAc1HHK/l1c32i?=
 =?us-ascii?Q?RY/ZVKZHJRTaMCN9VSGZDIP0yqETcU/HmnqE7HgTdPnlgnR3zWKIiMDezknI?=
 =?us-ascii?Q?UveCyUDE3Vk70k9Lst/cbrViw/Fxh746nKXjZjxf8Wp4dRlsLvO6e5xI8Lph?=
 =?us-ascii?Q?nFd953ThviKzD41JnNuP2t8wyyymXUqlhpetghONwgFXLCw8Hn3jyG/xIKp4?=
 =?us-ascii?Q?9HKkkOPVLDLfIV25c14JCRO8zAIxlTvGWP4+mVUSXcSW3gym2WpxAUt49e0H?=
 =?us-ascii?Q?2iVRuIi7wMLKLI+vlAJFBl3Eerpf4aoq0XjCXw+90qvEKIBM7R2MCx+lGCKZ?=
 =?us-ascii?Q?Cvq9A1xWQtdt9lRo/8z6WFQ7XHDrGNJRx0bQA+qv9qkcMWgK5KFhDpeUgLHQ?=
 =?us-ascii?Q?n7IS6r+ARAwqQypD7/XOKfmWHv6uDNubcuq+AHXlwk3wxhcLQ2htmJYuZ+wx?=
 =?us-ascii?Q?SNJ9ag/7sceqFiAYYPH8AE8wMKsdvVfW6qAwi0gRVRqyrov44H6jTVlvpKNH?=
 =?us-ascii?Q?rRuNgjIhssJlHGSAbhHVtX95VQ+vfe6APuJekgDTTA3YOWppkT/Sg7GI9DnK?=
 =?us-ascii?Q?vSJrgn8ZkCcs9u7JgADLf8KgFX4xiiWD85/JVsgKAsZA1lPbY5f9kvQki+ih?=
 =?us-ascii?Q?Oj5PtF9wtQmeO+hwMH5z/Gh8K405xe3V6DJXt8h2yFX4lCCvJU7xrLNfwkYu?=
 =?us-ascii?Q?+3gP49FkzUdNcRspDYQbAGf5U+TOb/ZVcnssJw7rJptVR5FNDN4xb3uLp1GX?=
 =?us-ascii?Q?EN/vx748rCeKgO87HybvioOe8umnA4tGdTo1BcIZMmQSJEazT/uodM/U6XE8?=
 =?us-ascii?Q?+qqQLUEyqV4ErITRyXToP7LJfdqhMMxJC+slTN3BMHv8D156VWwtfOjWTDnL?=
 =?us-ascii?Q?sojYheUkFxQrtaisQoEURG6odhIUoTgNsH8IBwz4A2Va1YNy2nxruH1TxWXM?=
 =?us-ascii?Q?P3cbtCUuyeSOinlKeZAbQ+Q1PUDmBhVAbtJU2IeANA6aTVrxwLlltvsniqWL?=
 =?us-ascii?Q?qemiTelrgYPcXVwjdxvh6Irlis6C+tbI+5LqvfDznbYcQuvymg/OHhpNRyjI?=
 =?us-ascii?Q?yJenovA0DBaXg7M5yO4eMyRbob71OCYt1ggjOqVWzOGPp9mOzEp/AP0RmEft?=
 =?us-ascii?Q?sceMNhPbUucZVs1RxzyddC+NfLtiXsD/oGTDW21ZNr9iOggqzJ1zS8mQFKTT?=
 =?us-ascii?Q?oFceIDQnkSf+X6JP89PTAVfNfczYyDeg+L7eKpToeUu0liWuWUdi3dfiNVBG?=
 =?us-ascii?Q?mORDIbX3EDq5jAn5XJ6IMiXbfrfpQXDyungu+SXGp3nUep+E1isVuPSV1Tzv?=
 =?us-ascii?Q?7EDpAgYjGn3jckb6Kaop+cu9iTLERrfGU2VP691Lk81tEa+NmbEEb0Tc73WK?=
 =?us-ascii?Q?hCPJiLmxuVRvWuxYntB2NBiJ9+Yap5DKeLAz5M1JkpdTrV/WOw11Gaz2rqA5?=
 =?us-ascii?Q?ZkySoPMMzjRjXEKq2Om6VdCxChZEa+ct5w+wrf8TAQo6FOrxlrH2bHE1jNGx?=
 =?us-ascii?Q?ndFlRryzxZ7qARHTxsnJv0Ke1evfmRLEctxYDsIfnhaiehLGHAJOb9nW6vSh?=
 =?us-ascii?Q?5PIutaBm5stWKvbTLNP5OTfDGjq71fUBxI9GaDUXXIVv5YOz7sBZ6TUbVA5S?=
 =?us-ascii?Q?go1T7W5kCFzmM1ESU1ysV9XZ04QuCXTtQS8iPbhirluhBLtBflduNcad5c2B?=
 =?us-ascii?Q?K934LXEK5PEt0WmUOKD+6f5VJN0=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9872bb03-27aa-4b12-faa0-08d9989eb3ca
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 16:36:04.0116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kzrfY3JxDR9Rz/DtNyAOaYlJUrFIFuw2euFIrcwEowqxTjHRcuSvX+joAiD8p/A9kp9L8ayc5+Eljf9U5zaS0yvWrAJWfDdHfR6YGmDoKVI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR02MB3772
X-Proofpoint-GUID: GBU2QWs-Oun4rt1fo8KPS7KxvjgMq78M
X-Proofpoint-ORIG-GUID: GBU2QWs-Oun4rt1fo8KPS7KxvjgMq78M
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-26_05,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For a page write fault or "page dirty", the dirty counter of the
corresponding vCPU is incremented.

Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
Signed-off-by: Shaju Abraham <shaju.abraham@nutanix.com>
Signed-off-by: Manish Mishra <manish.mishra@nutanix.com>
---
 virt/kvm/kvm_main.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 95f857c50bf2..c41b85af8682 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3083,8 +3083,15 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
 		if (kvm->dirty_ring_size)
 			kvm_dirty_ring_push(kvm_dirty_ring_get(kvm),
 					    slot, rel_gfn);
-		else
+		else {
+			struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+
+			if (vcpu && vcpu->kvm->dirty_quota_migration_enabled &&
+					vcpu->vCPUdqctx)
+				vcpu->vCPUdqctx->dirty_counter++;
+
 			set_bit_le(rel_gfn, memslot->dirty_bitmap);
+		}
 	}
 }
 EXPORT_SYMBOL_GPL(mark_page_dirty_in_slot);
-- 
2.22.3

