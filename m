Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD1967185F7
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 17:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234316AbjEaPSt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 11:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234375AbjEaPST (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 11:18:19 -0400
X-Greylist: delayed 1800 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 31 May 2023 08:18:16 PDT
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B921F10E;
        Wed, 31 May 2023 08:18:16 -0700 (PDT)
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34VCgsDQ005541;
        Wed, 31 May 2023 07:41:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=proofpoint20171006;
 bh=is1xOuLLOgUDArBZGh0CLxdZMx4ZFrd6aWilb7BCevM=;
 b=yMtPChwWSpY6qsXVVJJc3CtZ94ET3FWQIgmYva4mE8ijGU3IK/mAYbuH+HFJYYVjHsdn
 4tNYoYuxiCILBi0Bni4ur6Wi1upKjtHksz/Ic7i/JGksd/Q3XvTtwg253vpUfTBGxRY4
 8rDjrFCn5xqAinDyyWpVn68tvEsneb1AyyhM322mkj6BAz5SwKtuk3Hs6sMsl7Spv77P
 bF+1M9f7Gxe/lFyrfsKi5A+LaUk+zHJ7xIkociske7mjb4O12SZIK5feKbDueMcfXZqw
 q1jbKUMKw5rnzPbUNHNaai/DrEOnJEAOS8ueTfw9RtA3PieMzMx2zjtswGg4eBDiZzRA rA== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3qugxdfrxe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 May 2023 07:41:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UscUCIeMWdOa/yjc9OZp63+FsJmr7qun++N3/lUNCPsr0AQb/afT82uH11tToCl6/x/e06KYB/X9hydqFe9kXg+HttMb9QHKQw5x0BM5WiiVvAl81x+Ip6Ag/63uWqKAKq3Pzljt4UmE+vrPiYadbJMJ5WW58hIo+3a9wCDuP46sAKFrHRaXwxaBNCK61VR/C6SYolj4TG9qYbf5SFumhaw1GFSHa4tL+4rEfYpRjRJlF2kwS9ppXUqeIIQ1Fxf43l5DKpmzNapPFUTLDZYkeFi8sKStlUZCTycx1dD1fQ8njj//aLynY1lHgml1v7o1EyvY1OyU5s0B2mUnZnUeug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=is1xOuLLOgUDArBZGh0CLxdZMx4ZFrd6aWilb7BCevM=;
 b=cunl3XtaqOKVrumsWGChX0eg+X4pOSOAgTqp9eBAXrHNk7F6t3R7PDb6ZKhJlDa+9DNCcbjA7E9vF2Mhurx6QeOkM6xGPHuy/3YXBI1eItlQ7v+gA/lURarrDFgbwGRAHE3Qhf6n/hoeBC6RoBe+y5xTaVE7MS6KDzBEfiPDquJVLqAHNs694NAdvRYoqo7KfXrdaAdxCxVs4ZxetGnaZeUoT1fhEUtGwDefv6uQF2H3SBieHiV7FOfiI8qUbeCAy7Wj3+ENP0R6PlCkpTw25oTQAs6iPodGSz7Uq0ooHAbJKc54qBAAQVrohRORmeBQ3VG112V1d7/rICKQtc5KLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=is1xOuLLOgUDArBZGh0CLxdZMx4ZFrd6aWilb7BCevM=;
 b=mb4ufGUcp0i3Pj135h7D9RJOaIxD8GsDQPdu6XgG96D538oNn5HgBVut+u4cbpZ6Xf0mkeHks5pbuVA/pg2zUboaSUDFk6PdXLoKAFuz8bQGlMJw7qpTouDhMMcfkdWdeR2CAw3259+f9Z0qv6k7VHkV9q557SiFc4GgJFPZvgZ1ljtLht5gRj4V6Qp26CcSOU3o+CSJj5w4qjtpUbL1WR6pDc+IGpDmTA7wNoC73074gN4q8MUvVs8mTODGSGWvbPZtDpKdVd7NhhT26+nxTNfcfeXwRBCpH/JqQzq5iu3IgsXfnHEw96bXlaIho4EtwSm4SJGYD99E3cIbxkYbxA==
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by DM8PR02MB8247.namprd02.prod.outlook.com (2603:10b6:8:d::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.23; Wed, 31 May 2023 14:41:43 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b138:ab35:d489:67f]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b138:ab35:d489:67f%4]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 14:41:43 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Waiman Long <longman@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Jon Kohler <jon@nutanix.com>, Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH v4] KVM: VMX: do not disable interception for MSR_IA32_SPEC_CTRL on eIBRS
Date:   Wed, 31 May 2023 10:41:28 -0400
Message-Id: <20230531144128.73814-1-jon@nutanix.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0030.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::43) To BL0PR02MB4579.namprd02.prod.outlook.com
 (2603:10b6:208:4b::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR02MB4579:EE_|DM8PR02MB8247:EE_
X-MS-Office365-Filtering-Correlation-Id: ed03333d-6c15-40f6-d731-08db61e526e0
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BV+Ne0dQqEwk1HjlBZh28GazeHpwg1kh1PwSCM4JmxbAXqcznmrs9vJL5IPwmvpSO/FUblJP87et5WFU4yOzudn9Et1Uh1onB4G+Az3Zkzo3mi++P0EcyhXpgo8mkbjclmpWJVQgadcQbY3RbS/VhATxOoBBNQ24+wR0v51/FwEA1iZbOoss/ZQDH5+IuAUnhbwZWWHAd+kqe1snbyWALlEk2snTp+TVr2CkdA6zDF2GBCxKtu2ThWv9TjpIp6YcGzX4M52RM7+R+zSFke9VJ3jf8EYqOW4mYMJ6MvgOQPYcEZhyAK6KiZPtyjiYIZJmpYRJkHteIH5wb/M8a7391DouaCqxnPx380/Ky6Tn6OiJ0lLjfNnk4c15BTvAj6BKH+vUTCYiqLuT8y/zTGO6XrQE2IFSDUfhGHUuWwwW9TYEXtit+oS9GeU1a22ZqCGuJyE7SYtnYNNGUuOIYm5z46YZfFdrIWAkQXws7CVZTv+AazpGIFGzqH67fUY055i3Vc8jzs5ycXZ/J0vC4/zHi6565M9s8wnv8rj2XN9IcG+VNLE3wlHi9sw4BeaIZyvoBI4OL0r//R2a7yGg6w8xyxADhKifsQbivNj7zKQXOeXYU7Vccyo+wE1fd/qBTES9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(366004)(136003)(346002)(39860400002)(451199021)(2906002)(186003)(6512007)(6506007)(921005)(5660300002)(8676002)(8936002)(38100700002)(110136005)(2616005)(54906003)(1076003)(83380400001)(966005)(6486002)(86362001)(52116002)(41300700001)(4326008)(316002)(6666004)(66946007)(7416002)(36756003)(66556008)(66476007)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jd3vUnmmaofpKbAxWHy1exBy6vIqIFXNJjSTEsJYl1PbW0ZgskpjWYxuzSjc?=
 =?us-ascii?Q?c2ZMOWSiXFlconyfA3Bosf1B17T7pXUkbAFrH8vF73MwQuCRsyLXcFr+/azZ?=
 =?us-ascii?Q?XhZ3VldE7R0d5ztiuG2Sec0v4WxTh1OcWuNQ1OX0g33Qks9q8mpmdBHkZ/eO?=
 =?us-ascii?Q?xY9KnR/5KiyAcBfk755ybeEFHqWUzRRLPLPLChJYhxw0B/57bRlYNHSRx6W7?=
 =?us-ascii?Q?X220i14uAPiz5OpA5BU55vr1zak9XzUwExlmlvV7x7SwXqKJ4f4r3vmoTUdP?=
 =?us-ascii?Q?0DHFk0AP9UnDKMqoWXKtgGxCGQatlsrk+lBcvFHsprrT/3rVnTbrA5H3vx02?=
 =?us-ascii?Q?qFt7iBWd6N4CTAP92pT5P0A8Ricn06ENZAE+arXcMhc2NM8PCpAa9ICq5n2e?=
 =?us-ascii?Q?4mgmvnteHt13ee5ykaVB+1hQuekIFduODkN5vuLIAYBY+e+91ZzA5WJS6bZr?=
 =?us-ascii?Q?gfwt/yurFUJk7tSUrCY673WZ+U/Q0gxVZ0qedEvoQrpVg0XsnuhWuwbXGACA?=
 =?us-ascii?Q?cGlt6t1UlWWG1V27SrVi50wC7dyo8YNAX1YeJv+vTCvCOFcEh0Nz+tYTl1c/?=
 =?us-ascii?Q?sNltO6AFyYc8evglBBRtR4YCRfIdFfIDXskVv4E8U0/23RSjgR+HTcbBoUT5?=
 =?us-ascii?Q?eTz7KCkWyLAjvxgus6SP1cR6DwfsxxMlTH7IO/iytX9o9iqAVhcqizyTrIhv?=
 =?us-ascii?Q?QmHOqgnWVVw3PG7lFPgesM0wDgJPwhjO24v95CBg6ztucZuY/f2cQB4JqmYc?=
 =?us-ascii?Q?dnu7kQk13R5JqxRrUh3XzdHhf/8FQEYa1YDLC5OgRDeswcxJ/1i6Kh6nzKQK?=
 =?us-ascii?Q?ISu31C+7s3PYDUewGWrZrr/oucnOWVGTkkehNzczE5FWZSD1D7rroVav//fh?=
 =?us-ascii?Q?D5moAFkeMXjSctoKqhPT+xyOXG4G5JqlUoTkdk493txlxxNPDeVZqNJ79Oaw?=
 =?us-ascii?Q?WMpzsnhCTspTTBbjfCVsKDBLPXu5K+Zn9isIMaxo+us0b7aQL0XEkavYtJPM?=
 =?us-ascii?Q?81U92t9z+IMO4t5hMmRqHBu0do6LX9TMjHkdQbvkdRb5xtYSp8JtAH0r/0le?=
 =?us-ascii?Q?3PYrnevmBmVOVhnl6FsMh+0++bPvDObAxh4eVtpmszwzS3N5GTAw/z6LoW9e?=
 =?us-ascii?Q?/LRdlWzTrMxnoEv3nJq0fAjP9iACmkbCG6ml+PBkahG6zksN56WVv4cRv3Qx?=
 =?us-ascii?Q?Xt3GAonl0aq7k1yMiPd/QG+oLgRRjt0OH8lpqXWHqyBlvjteEC+FWp/Qlr0a?=
 =?us-ascii?Q?/0zbKRJsESt1a3Dezi/0Rn5CPv4PkfmEor+Ko4Plb4Ftnsekh/BVQiTpE+Db?=
 =?us-ascii?Q?lf59mwJEluqHNRXYx+rPQb9CFqINizQ8Qq/hVGSbmCexaY7gKqOeP+meBMJi?=
 =?us-ascii?Q?xx9fSB8aEcFsRCZU2iIzKKGkhHCXBeQg/WgejS2STR6Q4hRWyWYorczz9Vn7?=
 =?us-ascii?Q?qhNPtcA5QkmjSG70fP/eDIpKhU7eW6/Bkgh3uGEFdR1C/I+zaI64+OWn9igA?=
 =?us-ascii?Q?Q2zejeBCfh4F9ePntinXwzTZ+h6z3Db6ECNEIisCCcuIA5EvwT/DYnNWi2mN?=
 =?us-ascii?Q?t3VHyDVOFd3kDC3bOamMAOhD3J/o3NQ8f7Fl/8HAivn7wYthf+HOfJ6+rats?=
 =?us-ascii?Q?ydw8Qp+kWPA2v5W45sO5o+OMTl7IGZpAMoS/1GALAeFRtWuL373RXR6gLlIi?=
 =?us-ascii?Q?CdUBLw=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed03333d-6c15-40f6-d731-08db61e526e0
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 14:41:43.4935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mbVx7pMTNxpaInvr/zAfehWwB6pZhMGPoqJcqcZ+kfv3Iz+iIulytLjeIzF8vdK7IoEKjyFwZ7x9rQPfXoPA1eyC0zaBnl6u1hGGO22En1s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR02MB8247
X-Proofpoint-GUID: Qy2NFFLIPFo3PFRpz2YrMqUZCXyDHhAp
X-Proofpoint-ORIG-GUID: Qy2NFFLIPFo3PFRpz2YrMqUZCXyDHhAp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_10,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Avoid expensive rdmsr on every VM Exit for MSR_IA32_SPEC_CTRL on
eIBRS enabled systems iff the guest only sets IA32_SPEC_CTRL[0] (IBRS)
and not [1] (STIBP) or [2] (SSBD) by not disabling interception in
the MSR bitmap. Note: this logic is only for eIBRS, as Intel's guidance
has long been that eIBRS only needs to be set once, so most guests with
eIBRS awareness should behave nicely. We would not want to accidentally
regress misbehaving guests on pre-eIBRS systems, who might be spamming
IBRS MSR without the hypervisor being able to see it today.

eIBRS enabled guests using just IBRS will only write SPEC_CTRL MSR
once or twice per vCPU on boot, so it is far better to take those
VM exits on boot than having to read and save this msr on every
single VM exit forever. This outcome was suggested on Andrea's commit
2f46993d83ff ("x86: change default to spec_store_bypass_disable=prctl spectre_v2_user=prctl")
however, since interception is still unilaterally disabled, the rdmsr
tax is still there even after that commit.

This is a significant win for eIBRS enabled systems as this rdmsr
accounts for roughly ~50% of time for vmx_vcpu_run() as observed
by perf top disassembly, and is in the critical path for all
VM-Exits, including fastpath exits.

Opportunistically update comments for both MSR_IA32_SPEC_CTRL and
MSR_IA32_PRED_CMD to make it clear how L1 vs L2 handling works.

Fixes: 2f46993d83ff ("x86: change default to spec_store_bypass_disable=prctl spectre_v2_user=prctl")
Signed-off-by: Jon Kohler <jon@nutanix.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Waiman Long <longman@redhat.com>
---
v1
 - https://lore.kernel.org/all/20220512174427.3608-1-jon@nutanix.com/
v1 -> v2:
 - https://lore.kernel.org/all/20220520195303.58692-1-jon@nutanix.com/
 - Addressed comments on approach from Sean.
v2 -> v3:
 - https://lore.kernel.org/kvm/20220520204115.67580-1-jon@nutanix.com/
 - Addressed comments on approach from Sean.
v3 -> v4:
 - Fixed inline code comments from Sean.

 arch/x86/kvm/vmx/vmx.c | 35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 44fb619803b8..5e643ac897bc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2260,20 +2260,33 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;

 		vmx->spec_ctrl = data;
-		if (!data)
+
+		/*
+		 * Disable interception on the first non-zero write, except if
+		 * eIBRS is advertised to the guest and the guest is enabling
+		 * _only_ IBRS.  On eIBRS systems, kernels typically set IBRS
+		 * once at boot and never touch it post-boot.  All other bits,
+		 * and IBRS on non-eIBRS systems, are often set on a per-task
+		 * basis, i.e. change frequently, so the benefit of avoiding
+		 * VM-exits during guest context switches outweighs the cost of
+		 * RDMSR on every VM-Exit to save the guest's value.
+		 */
+		if (!data ||
+		    (data == SPEC_CTRL_IBRS &&
+		     (vcpu->arch.arch_capabilities & ARCH_CAP_IBRS_ALL)))
 			break;

 		/*
-		 * For non-nested:
-		 * When it's written (to non-zero) for the first time, pass
-		 * it through.
-		 *
-		 * For nested:
-		 * The handling of the MSR bitmap for L2 guests is done in
-		 * nested_vmx_prepare_msr_bitmap. We should not touch the
-		 * vmcs02.msr_bitmap here since it gets completely overwritten
-		 * in the merging. We update the vmcs01 here for L1 as well
-		 * since it will end up touching the MSR anyway now.
+		 * Update vmcs01.msr_bitmap even if L2 is active, i.e. disable
+		 * interception for the vCPU on the first write regardless of
+		 * whether the WRMSR came from L1 or L2.  vmcs02's bitmap is a
+		 * combination of vmcs01 and vmcs12 bitmaps, and will be
+		 * recomputed by nested_vmx_prepare_msr_bitmap() on the next
+		 * nested VM-Enter.  Note, this does mean that future WRMSRs
+		 * from L2 will be intercepted until the next nested VM-Exit if
+		 * L2 was the first to write, but L1 exposing the MSR to L2
+		 * without first writing it is unlikely and not worth the
+		 * extra bit of complexity.
 		 */
 		vmx_disable_intercept_for_msr(vcpu,
 					      MSR_IA32_SPEC_CTRL,
--
2.30.1 (Apple Git-130)

