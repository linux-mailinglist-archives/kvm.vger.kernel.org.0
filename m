Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E84A4F999E
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 17:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237663AbiDHPif (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 11:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232719AbiDHPid (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 11:38:33 -0400
Received: from mail.efficios.com (mail.efficios.com [167.114.26.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543552DE874
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 08:36:28 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 22EFE3D6E81;
        Fri,  8 Apr 2022 11:36:27 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id OVsLOWs2P0J6; Fri,  8 Apr 2022 11:36:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 868F23D6C54;
        Fri,  8 Apr 2022 11:36:26 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 868F23D6C54
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1649432186;
        bh=foOIpt3QdWaEiAfkzbobFr+04j9BlQOA6FpqU/h1vao=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=LlU8ZQg7rg/SMBdsjp5K1LYlVN9GVbeSoe9tq4X650lRf6WncBrg5W4C/vOk0Yaiq
         J01tsixdhkeW/HI3d8gjTmcYWJBWQfncbePmKnicR/ysxlv4IL55jj4iOFZSpoc2kl
         BCRsq8DHtS2/uH4R9Kv7o9WZE9lXpA6XjQWDZnaRogxQpNOmCLwHmnkwLkkEIexATN
         4ZTT2mbSVz8YqmxMaoy+moQf5Manz34PMQY3jMlNVFFOsEOJVNq/iPIxDtt3JeW2Eu
         8gG1uF78QI3fN5WJCZQWgvMK8imkEGCROSGi5dCFmLozGd1KBvh9MoCNOtTpWifT0M
         Wgn8dPBnZ9rHg==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id JIaQwEjoB1zm; Fri,  8 Apr 2022 11:36:26 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 791DC3D6C53;
        Fri,  8 Apr 2022 11:36:26 -0400 (EDT)
Date:   Fri, 8 Apr 2022 11:36:26 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, rostedt <rostedt@goodmis.org>,
        lttng-dev <lttng-dev@lists.lttng.org>,
        Michael Jeanson <mjeanson@efficios.com>
Message-ID: <1218866473.10909.1649432186473.JavaMail.zimbra@efficios.com>
Subject: Unexport of kvm_x86_ops vs tracer modules
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_4257 (ZimbraWebClient - FF99 (Linux)/8.8.15_GA_4257)
Thread-Index: LpIxIY9jLwbJ8q4CbGCDtwYhy2E0mA==
Thread-Topic: Unexport of kvm_x86_ops vs tracer modules
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean, Hi Paolo,

I have a question regarding a unexport of kvm_x86_ops that made its
way into 5.18-rc (commit dfc4e6ca04 ("KVM: x86: Unexport kvm_x86_ops").
This is in the context of tracing. Especially, LTTng implements probes
for x86 kvm events, e.g. x86 kvm_exit. It receives a struct kvm_vcpu *
as parameter, and uses kvm_x86_ops.get_exit_info() to translate this
into meaningful fields.

LTTng is an out of tree kernel module, which currently relies on the export.
Indeed, arch/x86/kvm/x86.c exports a set of tracepoints to kernel modules, e.g.:

EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_entry)

But any probe implementation hooking on that tracepoint would need kvm_x86_ops
to translate the struct kvm_vcpu * into meaningful tracing data.

I could work-around this on my side in ugly ways, but I would like to discuss
how kernel module tracers are expected to implement kvm events probes without
the kvm_x86_ops symbol ? Perhaps there is an alternative way to convert the
fields in this structure to meaningful information without using the
kvm_x86_ops callbacks that I am not aware of ?

The LTTng kernel tracer uses get_exit_info() and get_segment_base() callbacks
from kvm_x86_ops.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
