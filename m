Return-Path: <kvm+bounces-13029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CF5F890706
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 18:20:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B3DA29ECBE
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 17:20:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC2107EF1D;
	Thu, 28 Mar 2024 17:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JCPJwRD2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879325338D
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 17:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711646405; cv=none; b=O0qEz+jOtvcWHE+4dRqWToGOgwfxL1fi+ja44x8cACYrmt47Si5yL/P2/gLwdd040mE3re8mm3aIS2i2M66gXUJcRKqN39/OZN3ChJIPYPj4beggpg7tE6b9GYuT+oh0q3IkrofonCHh0mdUkVWs0445p3009VAs38u0Bxdves0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711646405; c=relaxed/simple;
	bh=4fOayRX3S5Jxu3sgYNPny0lYFK450ICrctDD0gaS9/w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=H+e77O4KXQrVE17oE/EWW1BSI5oSV8q3t3/SbUHkpN0+a3sCHeyGlvLGLRpJ86WzJRvQF/66POLYiRq17nARoQI+CBGT0eW9wna3LF9Tg8QkFOr6T7ATCbs38p1SHurq77KCDfDTmSnJUfaK5yYAqV4bGNqhUNiY9fmvQlC+ZNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JCPJwRD2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711646402;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FsmXoDAazFRAkcA6ArNgYSzB+6AfTdpq8nAX83CAIS4=;
	b=JCPJwRD2SA+NUn+qBesqDGaxmBuE22hNgVXb90Sa4ELYgGeyWNQczdVm5DPafxYo59co0M
	ru3JCt/0V1hyFzjB28Zz1eiCHOlcoDeU/0lI1Y4Ze9v06WeTD7iezQQE166/5W/PMXJN1X
	g3Q6YZNXtM2WLXImYhQ94O/uV37Qgmk=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-114-5FhinaUOMiuNTLc1TAL3Tw-1; Thu, 28 Mar 2024 13:20:01 -0400
X-MC-Unique: 5FhinaUOMiuNTLc1TAL3Tw-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-69181af8ceaso16362866d6.2
        for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 10:20:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711646401; x=1712251201;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FsmXoDAazFRAkcA6ArNgYSzB+6AfTdpq8nAX83CAIS4=;
        b=qyt3kAhLuo+Nf3QnlUIvchZQTw0sLpJgp7dEn6I3zCPnhDOWeDWnOtP5n9SMl78F0R
         tgD4G3roe5jv1c8B8IWjhETI5P4SujgE8z8W00+2WPMybJFpJBXuB1g8SkfLjtRfHKHO
         /O/F/iNBCU6iFuN+D0KMjnS1grg0d46y7v1zeZ2ebsVDH0mU1/dPWLimB/GsiQyAiYSH
         EFbikRou/l3HmPcGd5zR3tuMVRzuZl/4jQ9X0GxXkvsz5sxZ0/tqRgyJFElnQi1Pk4dr
         pc2SepU1bEwMlR//z7CX4FH0ql3S1JUwwvSCRbymLxU0G8Zmeg6Ldzf40jir2xkCMIsE
         DAFA==
X-Forwarded-Encrypted: i=1; AJvYcCUoDhcLVYbeoq9AyLqyNIq09FPvbrsec07bljuBhyAYtcu+Q1DLJKSPiCsIg1Xb+Fu69Y8C1u02VOS/oGbNIrbAa7PT
X-Gm-Message-State: AOJu0YxJwlXOIVWttbgRn+aPmL9gVYWFq4Rjn2+ZQn5/UwkLuF57lm4e
	YePP9bHP/p2G4n8CLmibrO3yN7FMEfheLzO36Pe4trHkJ4owC3dpjoR3RVhcsQFNljGGj3rtxnu
	QL7rlOoUBYQ23+xSxOnYtLpRx/IDmP1rIgmiCHXu5Jp/NZK1Btg==
X-Received: by 2002:a0c:e283:0:b0:696:533e:b003 with SMTP id r3-20020a0ce283000000b00696533eb003mr3622576qvl.18.1711646400878;
        Thu, 28 Mar 2024 10:20:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG+1wsa0IIYLVifTd3mmfaqBCTcpRrQtIhBo5V/XU7W0TxfgmUPDSlig2ELspzHcYJY7gn3jA==
X-Received: by 2002:a0c:e283:0:b0:696:533e:b003 with SMTP id r3-20020a0ce283000000b00696533eb003mr3622550qvl.18.1711646400549;
        Thu, 28 Mar 2024 10:20:00 -0700 (PDT)
Received: from LeoBras.redhat.com ([2804:1b3:a801:d7ed:4b57:3fcd:d5e6:a613])
        by smtp.gmail.com with ESMTPSA id m13-20020ad45dcd000000b00696944e3ce6sm809078qvh.74.2024.03.28.10.19.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 10:19:59 -0700 (PDT)
From: Leonardo Bras <leobras@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <quic_neeraju@quicinc.com>,
	Joel Fernandes <joel@joelfernandes.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang1211@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Leonardo Bras <leobras@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	rcu@vger.kernel.org
Subject: [RFC PATCH v1 0/2] Avoid rcu_core() if CPU just left guest vcpu
Date: Thu, 28 Mar 2024 14:19:45 -0300
Message-ID: <20240328171949.743211-1-leobras@redhat.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I am dealing with a latency issue inside a KVM guest, which is caused by
a sched_switch to rcuc[1].

During guest entry, kernel code will signal to RCU that current CPU was on
a quiescent state, making sure no other CPU is waiting for this one.

If a vcpu just stopped running (guest_exit), and a syncronize_rcu() was
issued somewhere since guest entry, there is a chance a timer interrupt
will happen in that CPU, which will cause rcu_sched_clock_irq() to run.

rcu_sched_clock_irq() will check rcu_pending() which will return true,
and cause invoke_rcu_core() to be called, which will (in current config)
cause rcuc/N to be scheduled into the current cpu.

On rcu_pending(), I noticed we can avoid returning true (and thus invoking
rcu_core()) if the current cpu is nohz_full, and the cpu came from either
idle or userspace, since both are considered quiescent states.

Since this is also true to guest context, my idea to solve this latency
issue by avoiding rcu_core() invocation if it was running a guest vcpu.

On the other hand, I could not find a way of reliably saying the current
cpu was running a guest vcpu, so patch #1 implements a per-cpu variable
for keeping the time (jiffies) of the last guest exit.

In patch #2 I compare current time to that time, and if less than a second
has past, we just skip rcu_core() invocation, since there is a high chance
it will just go back to the guest in a moment.

What I know it's weird with this patch:
1 - Not sure if this is the best way of finding out if the cpu was
    running a guest recently.

2 - This per-cpu variable needs to get set at each guest_exit(), so it's
    overhead, even though it's supposed to be in local cache. If that's
    an issue, I would suggest having this part compiled out on 
    !CONFIG_NO_HZ_FULL, but further checking each cpu for being nohz_full
    enabled seems more expensive than just setting this out.

3 - It checks if the guest exit happened over than 1 second ago. This 1
    second value was copied from rcu_nohz_full_cpu() which checks if the
    grace period started over than a second ago. If this value is bad,
    I have no issue changing it.

4 - Even though I could detect no issue, I included linux/kvm_host.h into 
    rcu/tree_plugin.h, which is the first time it's getting included
    outside of kvm or arch code, and can be weird. An alternative would
    be to create a new header for providing data for non-kvm code.

Please provide feedback.

Thanks!
Leo
									...
[1]: It uses a PREEMPT_RT kernel, with the guest cpus running on isolated,
rcu_nocbs, nohz_full cpus.

Leonardo Bras (2):
  kvm: Implement guest_exit_last_time()
  rcu: Ignore RCU in nohz_full cpus if it was running a guest recently

 include/linux/kvm_host.h | 13 +++++++++++++
 kernel/rcu/tree_plugin.h | 14 ++++++++++++++
 kernel/rcu/tree.c        |  4 +++-
 virt/kvm/kvm_main.c      |  3 +++
 4 files changed, 33 insertions(+), 1 deletion(-)


base-commit: 8d025e2092e29bfd13e56c78e22af25fac83c8ec
-- 
2.44.0


