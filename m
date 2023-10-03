Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3077B6AEB
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 15:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237689AbjJCNwv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 09:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232068AbjJCNwu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 09:52:50 -0400
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F555A9;
        Tue,  3 Oct 2023 06:52:43 -0700 (PDT)
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5230a22cfd1so1607257a12.1;
        Tue, 03 Oct 2023 06:52:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696341161; x=1696945961;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qbhD19S6zLeOtT2FNUeshWF95fV8Y1/bPKyfIl12gP0=;
        b=YT0XI35Z4m+v3MsnQ+bYMJfWA8a9DJJw56nZcLT23qRV0p1ldrx7nAap67AvoZCGQt
         sun3MVpvWCCnVAOSrYZu0af0Jsoq92WT4QQJle692N+1YAjvUoJ+EoyNjw0HdddlfBSp
         +yjQwdex+RmhMg9cu/dp6oADfa4sjNsT+IU7a2QIBZOreU1hv4iMVgj7BNq5eXBgY62+
         bJVRcaf2YRRUCcTKc6J1/kvgfNFbYKZ7n0/UBHYaAjt16qNEuUrZxzrZ0RL6UWCfj9b2
         sgVQsAYPGXBNLArENQiWgX+jH/2NDfiXdt2kbXlwwTkCo7xOqVCzywGTVJT4SqHuKfH5
         WS9w==
X-Gm-Message-State: AOJu0YyxQp7Wp+7bKIOwk4Dq9giyYzp34n9jQQZ8zplwTcxieKldO0Q9
        B1JhdYwAtisJei1KT21uGvhOEWg9VTU=
X-Google-Smtp-Source: AGHT+IFAGpUa7LltnP297SnJgjG9wRsCbtvps1bDOeBiWN2XiNo4p9pu/ruLocu0YnYfIcTd2D2GJg==
X-Received: by 2002:a17:906:5393:b0:9ae:3fdd:4dd with SMTP id g19-20020a170906539300b009ae3fdd04ddmr12445147ejo.24.1696341160973;
        Tue, 03 Oct 2023 06:52:40 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-120.fbsv.net. [2a03:2880:31ff:78::face:b00c])
        by smtp.gmail.com with ESMTPSA id d10-20020a170906344a00b00992b71d8f19sm1100772ejb.133.2023.10.03.06.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 06:52:40 -0700 (PDT)
Date:   Tue, 3 Oct 2023 06:52:38 -0700
From:   Breno Leitao <leitao@debian.org>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org
Cc:     rcu@vger.kernel.org, rbc@meta.com
Subject: kvm/x86: perf: Softlockup issue
Message-ID: <ZRwcpki67uhpAUKi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I've been pursuing a bug in a virtual machine (KVM) that I would like to share
in here. The VM gets stuck when running perf in a VM and getting soft lockups.

The bug happens upstream (Linux 6.6-rc4 - 8a749fd1a8720d461). The same kernel
is being used in the host and in the guest.

The problem only happens in a very specific circumstances:

1) PMU needs to be enabled in the guest

2) Libvirt/QEMU needs to use a custom CPU:
	* Here is the qemu line:
		-cpu Skylake-Server,kvm-pv-eoi=on,pmu=on
	* Any other CPU seems to hit the problem
		* Even using Skylake-Server on a Skylake server
	* Using CPU passthrough workaround the problem

3) You need to use 6 or more events in perf.
	* This is a line that reproduces the problem:
	  # perf stat -e cpu-clock -e context-switches -e cpu-migrations  -e page-faults -e cycles -e instructions  -e branches ls
	* Removing any of these events (totaling 5 events) makes `perf` work again

4) This problem happens on upstream, 6.4 and 5.19
	* This problem doesn't seem to happen on 5.12

Problem
========

When running perf in the circumstances above, the VM is stuck, with a lot of
stack traces. This is some messages:

	 kernel:[  400.314381] watchdog: BUG: soft lockup - CPU#3 stuck for 26s! [kworker/u68:11:6853]
	 kernel:[  400.324380] watchdog: BUG: soft lockup - CPU#8 stuck for 26s! [dynoKernelMon:9781]
	 kernel:[  404.368380] watchdog: BUG: soft lockup - CPU#30 stuck for 22s! [kworker/30:2:1326]

Here is part of the stack. The full stack is in the pastebin below:

	 nmi_cpu_backtrace (lib/nmi_backtrace.c:115)
	 nmi_cpu_backtrace_handler (arch/x86/kernel/apic/hw_nmi.c:47)
	 nmi_handle (arch/x86/kernel/nmi.c:149)
	 __intel_pmu_enable_all (arch/x86/include/asm/jump_label.h:27 include/linux/jump_label.h:207 arch/x86/include/asm/msr.h:147 arch/x86/include/asm/msr.h:262 arch/x86/events/intel/core.c:2239)
	 __intel_pmu_enable_all (arch/x86/include/asm/jump_label.h:27 include/linux/jump_label.h:207 arch/x86/include/asm/msr.h:147 arch/x86/include/asm/msr.h:262 arch/x86/events/intel/core.c:2239)
	 default_do_nmi (arch/x86/kernel/nmi.c:347)
	 exc_nmi (arch/x86/kernel/nmi.c:543)
	 end_repeat_nmi (arch/x86/entry/entry_64.S:1471)
	 __intel_pmu_enable_all (arch/x86/include/asm/jump_label.h:27 include/linux/jump_label.h:207 arch/x86/include/asm/msr.h:147 arch/x86/include/asm/msr.h:262 arch/x86/events/intel/core.c:2239)
	 __intel_pmu_enable_all (arch/x86/include/asm/jump_label.h:27 include/linux/jump_label.h:207 arch/x86/include/asm/msr.h:147 arch/x86/include/asm/msr.h:262 arch/x86/events/intel/core.c:2239)
	 __intel_pmu_enable_all (arch/x86/include/asm/jump_label.h:27 include/linux/jump_label.h:207 arch/x86/include/asm/msr.h:147 arch/x86/include/asm/msr.h:262 arch/x86/events/intel/core.c:2239)



More info
=========

Soft lockup messages in the guest:
	https://paste.debian.net/1293888/
Full log from the guest:
	https://paste.debian.net/1293891/
vCPU stacks dumped from the host (cat /proc/<vcpu>/stack):
	https://paste.debian.net/1293887/
Qemu (version 7.1.0) command line
	https://paste.debian.net/1293894/
