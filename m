Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D62B7BCEF8
	for <lists+kvm@lfdr.de>; Sun,  8 Oct 2023 16:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344898AbjJHOxM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Oct 2023 10:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbjJHOxL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Oct 2023 10:53:11 -0400
Received: from AUS01-ME3-obe.outbound.protection.outlook.com (mail-me3aus01olkn2156.outbound.protection.outlook.com [40.92.63.156])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD52A4;
        Sun,  8 Oct 2023 07:53:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hcPenzeoMVj3NWwKD1fZPwzFKRph1JZMs+VeDteEKOU8RFEcq4Kf+G7W6+OSNTC+oYUWzSPs6tU98ObLY7fpYqEB32HS5MFSlWUOrZwdB6aDuqyGSheLK6Mw9E7G6mlbxGeQQ1YvBa3Nf25wVg2o2OLr/FsWm0q6+3NwintCdxwdyV7n9PGcFtFdIPjEn3LG06FJUPynRM7rcAtdOyzag/PiL13sD4osXi+vc44uYcMWaw4mQwhRR7cdAwrbvDBGGKi8JSxBIH5gFweuxI3v5z2x9jRXHSuI7lsGGI/UhM0nnQMOYYEyRFBeZxhK92tAh8sT/j8cwcOY4UvttxiiIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4CxXtiQ9USb3dDRkpn0l1+Exe6nY1VWP5IqNPZ/uctk=;
 b=AIJYr3qWjzF1xcgbrXosLf0wgDHyuUF9waj1jZcKAp3ug3mbwLD0J1v07PKkcWjWfdH4cnu/3Jy7TBWSuFODMiD2BAwjPgqs+WfQFbptkfzg8Syr09JN7CQnAGfl9DOa7PywSt8Y+DF+u1mc+5tSPOY0YV639P0CRxXY5TtpHuOKNIvLT1kKEYxadDzApj/GemhNjUcofI09yyZdmiqq4u8wPlH8VYQ8WRFK7OKqQbChU8HDlKDe5U6X/oqL51sAu48j7PsPEFbNQYS3Xa+hYUMU69EeruPoFVvebhoXoS7vbOD8L5aG/c4Wz7IIWuinEdvV4Vqw8TN9oRGLmVibSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4CxXtiQ9USb3dDRkpn0l1+Exe6nY1VWP5IqNPZ/uctk=;
 b=BxxLcwRr7Brk6iKa9EjdbueLfhB//Q8NlEiihSA9vVZOP0R7+BOQY6/wYQOBtpdFPTnjgUGMjCFRPlwS5SxLeoiiWChMaV3MuJBR4OVjYbUK52hSMjOhG4Cc2WURTgGbOtSWCR5GFjR7zW/Msz8SQtWJR1s2lkSHXORsq33/zdXu5wgCW7nbMkOMYbHhQbu0anR03B7Gy/zznE1KcDsDAcCX88gXTqp1emlnZ7epigy0F1TVcsArou7ym1MMJxBGmXEFzCL+RP5WFtbBHqAyXPEC4jTvlmQ/EbZDFkNwRUOrOzh0WZe5WYi6/BJLoiN/uhxl6UReaNdHT6Frt+LIjA==
Received: from SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:ac::13) by
 SY4P282MB1371.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:a2::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6813.21; Sun, 8 Oct 2023 14:53:03 +0000
Received: from SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
 ([fe80::e39e:17fc:36d8:1ea8]) by SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
 ([fe80::e39e:17fc:36d8:1ea8%3]) with mapi id 15.20.6838.040; Sun, 8 Oct 2023
 14:53:03 +0000
From:   Tianyi Liu <i.pear@outlook.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        mingo@redhat.com, acme@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        namhyung@kernel.org, irogers@google.com, adrian.hunter@intel.com,
        Tianyi Liu <i.pear@outlook.com>
Subject: [PATCH v2 1/5] KVM: Add arch specific interfaces for sampling guest callchains
Date:   Sun,  8 Oct 2023 22:52:20 +0800
Message-ID: <SY4P282MB10840154D4F09917D6528BC69DCFA@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <SY4P282MB1084ECBCC1B176153B9E2A009DCFA@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
References: <SY4P282MB1084ECBCC1B176153B9E2A009DCFA@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [dT35Yg0Ztuvx/B/C13xQirvyaWVIvY1Jsoj0E78mW46eB3Mbm3wgrw==]
X-ClientProxiedBy: SGAP274CA0024.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::36)
 To SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:ac::13)
X-Microsoft-Original-Message-ID: <20231008145220.7220-1-i.pear@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SY4P282MB1084:EE_|SY4P282MB1371:EE_
X-MS-Office365-Filtering-Correlation-Id: b93ee731-1a71-405c-4f7c-08dbc80e459a
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aGsZAKOkUwNp2fXgX9x9kENhiCrK6+zipDPILE6muw/KvTn1Lny2mgsh9Wd/U0coAImxUPPcpENoYHlc+eMcWzLX0mZGoPe95/rNrg/MSe0Bn8JKxfQoFZ0NzuTP6McF1SncJkyYYodDnb3sRrIkSCj8iQaFXbAG7UU2TcCcTTvb7+a1yd2FyCpgKofvEWpnFWBORZhgZw/fe+UpMvhgBBNcLpKfKqmXc2l0QgtlI7pA6/Z4DJEbxagaQbe/vbCszzgprMFZJKE4HpXqvOuO4tVXxZmtI4IN1ACUeK+9Rw1QpPQWozXgBe4nRWBcJsieJoLxLXdjgl0YPJ+15awtbNladcU3eiK2+9jGWG9qR5Io/vdNemyq+NxtCUwmghlAOj7Kwc8puEN5K6rHVANWwJy7VtE4jwBfUSzjXoMwVCCxRnTzK3abCLOHSpr/4DzL3Jx1h5LqMcNykS94AzsUuqBwWrHV78+WGqv7G0DwALulXdAVQRGa/kasnLMKXX4aUVny84jPdYIxZx/TTXdH54lNQIdgvjq1JID0E+vIvwZc0ZWHfa5j7Abv4XdVMXn1K4tTvKRngBoC79LzoNIoF2QyisR1Mh+xAezNnQ/ALvMjsWXCOqIuFFnM0Od/4o2K
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4l2IwV3BplunpSkqMvgynTu/CBdmRU3be8ph6Jxf9L29TYc9c2nQdMcp2bWR?=
 =?us-ascii?Q?GTqIaCBdhA32nMiCNUqlZ8S0QwBivtxV7m1vLPgMFJ6bS5WgavG0NZy5dw08?=
 =?us-ascii?Q?0l+MdrpBLgcMS83TD9zsqfFRFp3UffCF4vkVq5FVUDAiE6Nt5hvE1DpUQZly?=
 =?us-ascii?Q?zpjUJeKcjOA9R/WpHYobCEI/snhzsgqGIukKXyHAfkEeHvYiISIY/8DC2HcG?=
 =?us-ascii?Q?vP/aHz+6qNYcRkol/ExpnCvbmZ+mo2eM48ulTKYKJvBTN8m2+g9z4EA9y2Ue?=
 =?us-ascii?Q?eQ5JO+90Mit0Bcap5UWKKreIopUTz9k9aUOyp6zyciIM1QXZbeDyNQkD7TCu?=
 =?us-ascii?Q?hKKPI2RMB5l4EJeT0R/iWQCTGS/yhXgGGCpR0fd8V1ljGcP1LwuV0aan0zZj?=
 =?us-ascii?Q?013yv/yZb9yvXYs49MAMEGqIDagkmwLPyDQ89Dgl5x8h0GjP3igm5J5GPYzH?=
 =?us-ascii?Q?HGNKrR23HJ5OJ4e+9IEfyg9Fgzr+tu1FQNIr2j2Vfnpz/AwnTS0t6ZRh1kxj?=
 =?us-ascii?Q?OWGna1J+GByUvTd6x9GvZ7ucoaDZjMcJuulQgtGFy1vX+SX1wHMZLoU5Q1Fd?=
 =?us-ascii?Q?M4UIDDgFtYiYpnieshiyiot2qFlJzZNV8+5f8IV3dLfakto77wIdIesqqLIB?=
 =?us-ascii?Q?vhGY6FQEw9mrvBj59T3jvMnSebU41WQTNCh9B2dB1fXUQ9Z9YxUCRBBLK3zK?=
 =?us-ascii?Q?w9EStrMV7WQq2u4YyXzPmzeM3UGr6f3tfJI4a/iJrPJ+mZn7jACIj4WBhflY?=
 =?us-ascii?Q?5v27n6zXgO5rHNCWB1o+V5W7pOVIBZVRfCpDMRTbyWnnt2vbjcNl1XbUpE1H?=
 =?us-ascii?Q?OmM1O2PJi3+hmPen4lkIg0x2rOfJDvZrTykc9wZRbSF/EZ5p7uhfciFrIL5e?=
 =?us-ascii?Q?SKMmnLANBdKKXM4sdjJJDvhVwi90lVljMRjeOpa8vg/f89VoqS6Qr/6pr1EQ?=
 =?us-ascii?Q?udsriEf1nkzSMXdWVa/Ms12m3S4bcU8GVJb+DGjHAR/EXtJafjAUlh2gffZN?=
 =?us-ascii?Q?Ps/IPNWrxb4FE8Hziw965Pf5UGIWB0A9xxUQCxQcMijYQlOuHLhTSFsOkIkk?=
 =?us-ascii?Q?H1KpQ5CFKs+QK6CjV+ij6vWvmKIVImPQ7ui1EJHbTMLqHEuHtdxwhypVxPwM?=
 =?us-ascii?Q?jQFvtp4SZ3wM5hOgbLvmgpCDCfbQXKbzKTEdIWYof7mBrEK01T28HQGt9dyr?=
 =?us-ascii?Q?/DrTYM1uKMxs1ZS19UtVxv2zEx0GWmsYAAN800fwPGFmYh6pw6alYX1c11ze?=
 =?us-ascii?Q?CkxMj3aMtpwZNbpJI431?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b93ee731-1a71-405c-4f7c-08dbc80e459a
X-MS-Exchange-CrossTenant-AuthSource: SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2023 14:53:03.7523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SY4P282MB1371
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds three architecture specific interfaces and x86
implementations used by `perf kvm`:

- kvm_arch_vcpu_get_frame_pointer: Return the frame pointer of vcpu,
  for x86 it's RBP, and for arm64 it's x29.

- kvm_arch_vcpu_read_virt: Read data from a virtual address
  of the given guest vm.

- kvm_arch_vcpu_is_64bit: Return whether the vcpu is working in 64-bit
  mode. It's used for determining the size of a stack frame.

Since arm64 hasn't provided some foundational infrastructure,
stub the arm64 implementation for now because it's a bit complex.

Signed-off-by: Tianyi Liu <i.pear@outlook.com>
---
 arch/arm64/kvm/arm.c     | 17 +++++++++++++++++
 arch/x86/kvm/x86.c       | 18 ++++++++++++++++++
 include/linux/kvm_host.h |  4 ++++
 3 files changed, 39 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 4866b3f7b..b57b88c58 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -571,6 +571,23 @@ unsigned long kvm_arch_vcpu_get_ip(struct kvm_vcpu *vcpu)
 {
 	return *vcpu_pc(vcpu);
 }
+
+unsigned long kvm_arch_vcpu_get_frame_pointer(struct kvm_vcpu *vcpu)
+{
+	/* TODO: implement */
+	return NULL;
+}
+
+bool kvm_arch_vcpu_read_virt(struct kvm_vcpu *vcpu, void *addr, void *dest, unsigned int length)
+{
+	/* TODO: implement */
+	return false;
+}
+
+bool kvm_arch_vcpu_is_64bit(struct kvm_vcpu *vcpu)
+{
+	return !vcpu_mode_is_32bit(vcpu);
+}
 #endif
 
 static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9f18b06bb..17dea02b7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12904,6 +12904,24 @@ unsigned long kvm_arch_vcpu_get_ip(struct kvm_vcpu *vcpu)
 	return kvm_rip_read(vcpu);
 }
 
+unsigned long kvm_arch_vcpu_get_frame_pointer(struct kvm_vcpu *vcpu)
+{
+	return kvm_register_read_raw(vcpu, VCPU_REGS_RBP);
+}
+
+bool kvm_arch_vcpu_read_virt(struct kvm_vcpu *vcpu, void *addr, void *dest, unsigned int length)
+{
+	struct x86_exception e;
+
+	/* Return true on success */
+	return kvm_read_guest_virt(vcpu, addr, dest, length, &e) == X86EMUL_CONTINUE;
+}
+
+bool kvm_arch_vcpu_is_64bit(struct kvm_vcpu *vcpu)
+{
+	return is_64_bit_mode(vcpu);
+}
+
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 {
 	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index fb6c6109f..f92f1a9c8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1595,6 +1595,10 @@ static inline bool kvm_arch_intc_initialized(struct kvm *kvm)
 
 #ifdef CONFIG_GUEST_PERF_EVENTS
 unsigned long kvm_arch_vcpu_get_ip(struct kvm_vcpu *vcpu);
+unsigned long kvm_arch_vcpu_get_frame_pointer(struct kvm_vcpu *vcpu);
+bool kvm_arch_vcpu_read_virt(struct kvm_vcpu *vcpu, void *addr, void *dest,
+			     unsigned int length);
+bool kvm_arch_vcpu_is_64bit(struct kvm_vcpu *vcpu);
 
 void kvm_register_perf_callbacks(unsigned int (*pt_intr_handler)(void));
 void kvm_unregister_perf_callbacks(void);
-- 
2.42.0

