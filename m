Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0841F763CB0
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 18:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbjGZQnN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 12:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbjGZQnL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 12:43:11 -0400
X-Greylist: delayed 472 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 26 Jul 2023 09:43:09 PDT
Received: from newman.cs.utexas.edu (newman.cs.utexas.edu [128.83.139.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4074926AE
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 09:43:08 -0700 (PDT)
X-AuthUser: ysohail
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cs.utexas.edu;
        s=default; t=1690389316;
        bh=rBMObIQhhJEl8aY038KCwr/KSgLbcItTIglPZPbruQc=;
        h=Date:To:From:Subject:From;
        b=kvSI4/NrRpPzEGfMUnALBPUY/OiegDvdunNwYnN04whpjSHLXU/zc6XCEQgHRI10+
         Yyk2mTzxyHeRgDGy+GJSn1dDGkRqUsM453fzTPG1gK0KthXV9JGMsL3WWqKk5bgw/n
         /dUt51mMHDWXWsffI4pMsvB9DGFZumXJhqoP2JfM=
Received: from [192.168.0.202] (71-138-92-128.lightspeed.hstntx.sbcglobal.net [71.138.92.128])
        (authenticated bits=0)
        by newman.cs.utexas.edu (8.14.4/8.14.4/Debian-4.1ubuntu1.1) with ESMTP id 36QGZFgJ015999
        (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 11:35:16 -0500
Message-ID: <7b5f626c-9f48-15e2-8f7a-1178941db048@cs.utexas.edu>
Date:   Wed, 26 Jul 2023 11:35:15 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
To:     kvm@vger.kernel.org
From:   Yahya Sohail <ysohail@cs.utexas.edu>
Subject: KVM_EXIT_FAIL_ENTRY with hardware_entry_failure_reason = 7
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.9 (newman.cs.utexas.edu [128.83.139.110]); Wed, 26 Jul 2023 11:35:16 -0500 (CDT)
X-Virus-Scanned: clamav-milter 0.103.8 at newman
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I'm trying to copy the state of an x86 emulator into a KVM VM.

I've loaded the relevant state (i.e. registers and memory) into a KVM VM 
and VCPU, and tried to do a KVM_RUN on the VCPU, but it fails with 
KVM_EXIT_FAIL_ENTRY and hardware_entry_failure_reason = 7. I looked 
through the KVM source and Intel manuals to determine that this either 
means that the CPU is in an interrupt window and the VM was setup to 
exit on an interrupt window, or that a VM entry occurred with invalid 
control fields. The former is not possible because my RFLAGS.IF = 0, 
meaning interrupts are currently disabled, so I think it's the latter.

Is it possible for someone using the KVM API to set the VMCS to an 
invalid state? If so, what fields in the kvm_run struct should I check 
that could cause such an issue?

Thanks,
Yahya Sohail
