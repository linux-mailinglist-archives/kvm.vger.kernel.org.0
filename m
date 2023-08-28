Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 845AE78A880
	for <lists+kvm@lfdr.de>; Mon, 28 Aug 2023 11:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbjH1JJJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Aug 2023 05:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjH1JIs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Aug 2023 05:08:48 -0400
Received: from AUS01-SY4-obe.outbound.protection.outlook.com (mail-sy4aus01olkn2150.outbound.protection.outlook.com [40.92.62.150])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04D8EC;
        Mon, 28 Aug 2023 02:08:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aZO+OxFzU1wzRX89kt/Gf6TOy0f/B3O/KZEXu3GskZot/sPg0xcewP5MUN9yPA7XOxfVu9aLioDJcJSLP2vCV5v/s5rH6QrV/fijsHR/gOBYebhpIKR2JMD3xsfrG4klF9jNFFf5YaWYmoHsr4e5GgxQB+N1psnz47ZdmL5VEji6RudTNpsLJvx/Hl8I3wW6EeTO1OeiNaOO+Z8jEpzQt3hbMibmS8WY6AhG7ep88XlN8svDUg9mLJzXp7jGvIyHupt4kCJ5a59ipYnb1HoDO8qsNgA1FMUQ4dEYrAgsL51cVD58xYuGGaqK+MUzGkCx+iiRyqW46UdTfvHu1jAuIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jKhhb45qakiRY3VC6LQnRVKOQiyKkazHDrWcOJmRd9I=;
 b=V1JKlTjE1khZL1AwCQvYME/NM4nxoxEnq5VKK0bUpFxX7gR9WCt0W6i7aQa50PmXPUMsaT9+2z8Ug2/62cdmtbfju75B4DeGHXY0YUQlo/CPTuf51AqWVEt0eTOuwxaRLnZWG9/u3YmcNtYYq0VYtkoyLZr4dP8oVOauv1sI0bH17sg/flsypf2gEtJR287B146BbvmYHRkdDt6RHzSuw7OmoFBYe6Eo76vPV7pHIEoCNQlH18SccKQ7LyAH8Xuv+abeZrhplwwxgSOR7egR9l5ETtwwLM7ptDzR0+H5gxnyDzsWgvBfV9Im5emgVC6J2BiaL01d7/v3Lmkw+EnONg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jKhhb45qakiRY3VC6LQnRVKOQiyKkazHDrWcOJmRd9I=;
 b=mPUmLopPSt31dzEC/514O2pOe/VkoG1qKqcYHOrCJEVN2JuUCrZvVq0R3iJVV0k7rvqFea21xKh0/k/9tIhgJhiqbgArjhLHjt6wTULkhOhp/lLUPX8pbUGCby03GADia9CCuvc2EKmbU9cVgBiDAKQ3BGfFAwy4n7AI2g4ix9JXf88D3y0EP6sM///La7qOcNqFBOSdtj+QJzheMwXsYqse4F5dDUEHx1EiteGuzjc2S7hHwmUtT6oCj1TPntdxWcsaSBxEOfIETdF1u66X8hfN6rMt1cn8X7IJXQkzRNa9x8OFAgm7VoZzcU1jPjDIm7UmeDF6jGWKkhHAIZVneQ==
Received: from SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:ac::13) by
 MEYP282MB2584.AUSP282.PROD.OUTLOOK.COM (2603:10c6:220:11e::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6699.34; Mon, 28 Aug 2023 09:08:41 +0000
Received: from SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
 ([fe80::62ca:cc8a:e3db:1f2c]) by SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
 ([fe80::62ca:cc8a:e3db:1f2c%7]) with mapi id 15.20.6699.034; Mon, 28 Aug 2023
 09:08:41 +0000
From:   Tianyi Liu <i.pear@outlook.com>
To:     seanjc@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, Tianyi Liu <i.pear@outlook.com>
Subject: [PATCH] KVM: VMX: Fix NMI event loss
Date:   Mon, 28 Aug 2023 17:07:59 +0800
Message-ID: <SY4P282MB10841E53BAF421675FCE991D9DE0A@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.41.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [cWc8n+iUqzHmtkk4okZcHOwed3ktIshq3V+VAoI/AVrRqEWuiGNGGg==]
X-ClientProxiedBy: SI2P153CA0033.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::21) To SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:ac::13)
X-Microsoft-Original-Message-ID: <20230828090759.1867-1-i.pear@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SY4P282MB1084:EE_|MEYP282MB2584:EE_
X-MS-Office365-Filtering-Correlation-Id: 64350467-0185-4828-2beb-08dba7a65f7f
X-MS-Exchange-SLBlob-MailProps: ymJijV9pwJlrrluThJ+JdRbaZEbpimv0jkv0dvpP/hgujflfnrzU3GALhsh6H3Jb71GFzUX2nPyHWiLNTEVSUDbHsMBNaj2PuhIG4YMPPel5X4zNs9YyYKf09iFMrUAsStqrzrKoJoeKrbSzX+NjXs/jOx+rqvMxgm18cIjoRMhU8qfcmP3ulesS7aDjNrrU5g5Y5jDNeNMLSBnQOD7VHOjzlRDzO7fhpzuoZm7/No2T2++TRaKx9tm8PsvtD6T2sS2DWTSw/0wmC7VCSZ70XbxKkzVCCaf916GRemllfEtkds5k4p9Guk9B04hNzdxd8t+PqsHZ2SKpDwKP0dqzOdY6o4wFUaQ6a4DBb9DctjCWf6V8HlPmSSMYuODHUiAyQdZVUVSGH81/cj4+Fjks4WyWISV92w4/R+3/4VVSqX0dio9UxXC+UyvZjAzVMBTeBOEtkHkFF2lbqIx9PsCTZiKzmTc/ZIVnaIJUZyru4JQ+yNxQKTEKW7ENboa8F86wIEDMqUFmHpsYTf0USDq9cohd2ql254e1zNMCZ+Vm2oMsaeH7vi4s+fPPFrPvwhJ1R9HtE7XCRyTsvl+yXwrIzy6rxTGnxucIM9GIJHSIKXg2Ganvkg5GGkqkNhvGU8uHfZrTTGhY1Xcu2m6IbiycY79HJWyXrx986IgIjXQAmXuhi8wst6y4PAqEEZ3jyt/MKaeMm1facYLkqz/94A8XAtCeqy7HQ+4YDq3Y5US+VMtQIHAtyRtDfQCgUkLS1HjD3tzWnDUAIHZaQpFjWkYBIJazRQ1SmGRkIldl7RrJ/2hIdc4mJDazVHhSv1Gwy8nE
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EVkn/elQomZNZzcsriNeXRB4c9gxlh3TZUsSP/lLezPHWJ4tJZ4W6TbDEJwGSOOy7XOXrJmE+oyUN2olz+zSL8STpr8UqTMADC4pCC8KeUJCiU+bKCYv4tZXmKVLyF4X4gr8i/uG6UpRjrUscTK8yGUIgYgRGiZMIHFolBfiaRBTtaXmKmEW40TU5KBK03CueZ9VqvNXeBgmmuRtVIgUbBUAbxVQ7v193h4ITKZY5z3IHVyv7UM5ovJ8LYBvCaTg9UtLUV+uPYIrvJJZjrNh998IIVMp/0WcYAf2Ltx/onre9+SHNosEP98fchGtcFsldM1xGMNUSDDB8ceZfRL4X32dvFSqmYFnbyUVLebVJs5V9GjYjohmyYTL1xg9/mxflRUEJWrItvaojuh5moZODclBuo5NkTIkCHWSvQh4LzodswbF5aGTghgb+pOYfgCj+evMsoXEr4l1r8yE4PQ4p9J6Hm4hOpsaZ9GaBA82BpBi7LKc66/rbSTDrNWVuEZ+SpJ0IQG4IGoyI9rH/ghXeCj+CnONop2N1xG6deUDKlhBJNE6VUpAdiB/jgBeG06YAHnmDZ24K1rw+asZQZYv0d/mPFMzBNZnWyI3piXCU0U=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KjkwK9RVp5VdZrx2hdTgn42UmhtmDtMZrsAjkLh9RXDkSz4ch6axkKgVYkS8?=
 =?us-ascii?Q?m7DWpmcNqn9DE2rFJrFdQee1F/CMmatbK3884CGz53rCaBlIKDzRZdqEW92G?=
 =?us-ascii?Q?N264FwC0wxKi4bS5wOtv4M1KgPT4Fy21x+PpNX8t39apUku92OyDraxF5Q1T?=
 =?us-ascii?Q?SzvbMQbzegIH0M+4ogZDjazn6pZNYdI6pR7l8GTkjXx8g/YGmYv9yP2e37v0?=
 =?us-ascii?Q?Nx+IeDdmhS0bgQUejO4nckh5PYQnSYWof/8FIaShMYRF0/XxCTECkI9sMGr9?=
 =?us-ascii?Q?QlJS+CYr/dWr3ZM9I5AOA/XtbJNQ8/wUueQkWZRm2Hey6AUf3wuw5maTFqGr?=
 =?us-ascii?Q?F3bGTGkoOW+jvDPj6VVzCKrqcAaWVvD06tAKR04v0Q4u2df3ZTYtIYh9IDrs?=
 =?us-ascii?Q?+vCuDjSXptdGDmOWlRZvqJZ+KV9xbnVjRAYdCGZOXjPpor951wlP4pOezzHI?=
 =?us-ascii?Q?Hj62+4bFjvyZmT1VRNph43eO9/jNwkLZxFIFqbbXy+E6goUb1U3hPjKRC+H7?=
 =?us-ascii?Q?lL9lraIK5R4g8KElJ/RmN2by2dCNroPEa+cSy8QVZJ8XcOlykuIDJh3QzY20?=
 =?us-ascii?Q?7j9nfR7JVsS7g+4kLP+e/74bJn81lXbZhm92rgnW49cyuzrdHrxXXj/qzffb?=
 =?us-ascii?Q?07RiVJJpuOlvP9+XiWj/ptiucNDtop2nm91tudK/qJ/sx+0yxBcV7p+fq4C3?=
 =?us-ascii?Q?hsn9cH1X+Wln0y4p4dSLC3iiRTYYUfjOoPYqbkMFcYbwCcSG6pjljdmH1So+?=
 =?us-ascii?Q?DcH5mqK2/M6Xy9MGDZdUA7T/lGyzhswm3Ds5nSOuYgPI22NCZEX27+7YN7+S?=
 =?us-ascii?Q?yAMYamXGPW/7EjntEmdZyBU3tePjfH0cQqCM7Yex2EY08I65Ghx6k/BXB5ZO?=
 =?us-ascii?Q?xIjXOtoTgut80PKi/zJjm++/UO4u0oXxzVYbGXgvx/gnJPjWAo0KicBRUTRm?=
 =?us-ascii?Q?fZZgAXMMvzOit7rqXyVzeRKJi/Xdw9BTHO4FUPqy/a+YAKw0FH/JHkFIaRQP?=
 =?us-ascii?Q?lFxvX3TY/oe8D7W0x6vHmc1nUPTlp9F46xnOJk8ccWyGw/bSY81+XLlLQNN1?=
 =?us-ascii?Q?Wnds3DwJBuN7Ah0+R0kfF3Pu6svMzFzqoeani7xI8DwSQDBHFeAd+TG8HD7n?=
 =?us-ascii?Q?cRA8xtCQprwjbOzEf6IDq1huFlNnVdK6YknIlNpha01A5LnO5b3uv+sbfc2u?=
 =?us-ascii?Q?dHP8G42mxrnWG9JGwU7f0oAuT8lM3rHj43iPVTjFRimK9KwLRbyz32B6xHXk?=
 =?us-ascii?Q?SyM6qiMnNxVTVEneUq1t?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64350467-0185-4828-2beb-08dba7a65f7f
X-MS-Exchange-CrossTenant-AuthSource: SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2023 09:08:41.4372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MEYP282MB2584
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Sean:

I have found that in the latest version of the kernel, some PMU events are
being lost. I used bisect and found out the breaking commit [1], which
moved the handling of NMI events from `handle_exception_irqoff` to
`vmx_vcpu_enter_exit`.

If I revert this part as done in this patch, it works correctly. However,
I'm not really familiar with KVM, and I'm not sure about the intent behind
the original patch [1]. Could you please take a look on this? Thanks a lot.

My use case is to sample the IP of guest OS using `perf kvm`:
`perf kvm --guest record -a -g -e instructions -F 10000 -- sleep 1`

If it works correctly, it will record about 10000 samples (as `-F 10000`)
and it will say:
`[ perf record: Captured and wrote 0.9 MB perf.data.guest (9729 samples) ]`
And if not, it will only record ~100 samples, sometimes no sample at all.

If it's useful for your debug, The callchain of `vmx_vcpu_enter_exit` is:
vmx_vcpu_enter_exit
vmx_vcpu_run
kvm_x86_vcpu_run
vcpu_enter_guest

While the callchain of `handle_exception_irqoff` is:
handle_exception_irqoff
vmx_handle_exit_irqoff
kvm_x86_handle_exit_irqoff
vcpu_enter_guest

[1] https://lore.kernel.org/all/20221213060912.654668-8-seanjc@google.com/

Signed-off-by: Tianyi Liu <i.pear@outlook.com>
---
 arch/x86/kvm/vmx/vmx.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index df461f387e20..3a0b13867a6b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6955,6 +6955,12 @@ static void handle_exception_irqoff(struct vcpu_vmx *vmx)
 	/* Handle machine checks before interrupts are enabled */
 	else if (is_machine_check(intr_info))
 		kvm_machine_check();
+	/* We need to handle NMIs before interrupts are enabled */
+	else if (is_nmi(intr_info)) {
+		kvm_before_interrupt(&vmx->vcpu, KVM_HANDLING_NMI);
+		vmx_do_nmi_irqoff();
+		kvm_after_interrupt(&vmx->vcpu);
+	}
 }
 
 static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
@@ -7251,13 +7257,6 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	else
 		vmx->exit_reason.full = vmcs_read32(VM_EXIT_REASON);
 
-	if ((u16)vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI &&
-	    is_nmi(vmx_get_intr_info(vcpu))) {
-		kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
-		vmx_do_nmi_irqoff();
-		kvm_after_interrupt(vcpu);
-	}
-
 	guest_state_exit_irqoff();
 }
 
-- 
2.41.0

