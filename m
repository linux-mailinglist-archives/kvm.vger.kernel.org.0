Return-Path: <kvm+bounces-6083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B571682B017
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 14:59:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 658192822FB
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 13:59:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39B703C092;
	Thu, 11 Jan 2024 13:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EPX3y6H8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B446D17989
	for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 13:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704981547;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=UJCpiBiFJp+ilkkdFnmazVyEABhFVrNwz/OOCsk4Ogs=;
	b=EPX3y6H8UfMZmX/LcIwbp5JKrKJUrA29KcT1aS/BHfL2kiQiJb81lpjDJhugIvJ1P1PHK+
	UMTEHMQwzdL2JoFxfOELf7YPgEJXhQ+1t0zyE3eoKsz6M8QNlVlkisvIyDmgQrCnehG0Jr
	hR6zj7QfO5k+Y8mVDVWk9Pu1q9p7Ukw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-673-kknnswe1PSKrWVAeKbUdLA-1; Thu,
 11 Jan 2024 08:59:03 -0500
X-MC-Unique: kknnswe1PSKrWVAeKbUdLA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DC9163812597;
	Thu, 11 Jan 2024 13:59:02 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.159])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CE41440C6EBA;
	Thu, 11 Jan 2024 13:59:01 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: David Woodhouse <dwmw@amazon.co.uk>,
	Jan Richter <jarichte@redhat.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: selftests: Compare wall time from xen shinfo against KVM_GET_CLOCK
Date: Thu, 11 Jan 2024 14:59:01 +0100
Message-ID: <20240111135901.1785096-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

xen_shinfo_test is observed to be flaky failing sporadically with
"VM time too old". With min_ts/max_ts debug print added:

Wall clock (v 3269818) 1704906491.986255664
Time info 1: v 1282712 tsc 33530585736 time 14014430025 mul 3587552223 shift 4294967295 flags 1
Time info 2: v 1282712 tsc 33530585736 time 14014430025 mul 3587552223 shift 4294967295 flags 1
min_ts: 1704906491.986312153
max_ts: 1704906506.001006963
==== Test Assertion Failure ====
  x86_64/xen_shinfo_test.c:1003: cmp_timespec(&min_ts, &vm_ts) <= 0
  pid=32724 tid=32724 errno=4 - Interrupted system call
     1	0x00000000004030ad: main at xen_shinfo_test.c:1003
     2	0x00007fca6b23feaf: ?? ??:0
     3	0x00007fca6b23ff5f: ?? ??:0
     4	0x0000000000405e04: _start at ??:?
  VM time too old

The test compares wall clock data from shinfo (which is the output of
kvm_get_wall_clock_epoch()) against clock_gettime(CLOCK_REALTIME) in the
host system before the VM is created. In the example above, it compares

 shinfo: 1704906491.986255664 vs min_ts: 1704906491.986312153

and fails as the later is greater than the former.  While this sounds like
a sane test, it doesn't pass reality check: kvm_get_wall_clock_epoch()
calculates guest's epoch (realtime when the guest was created) by
subtracting kvmclock from the current realtime and the calculation happens
when shinfo is setup. The problem is that kvmclock is a raw clock and
realtime clock is affected by NTP. This means that if realtime ticks with a
slightly reduced frequency, "guest's epoch" calculated by
kvm_get_wall_clock_epoch() will actually tick backwards! This is not a big
issue from guest's perspective as the guest can't really observe this but
this epoch can't be compared with a fixed clock_gettime() on the host.

Replace the check with comparing wall clock data from shinfo to
KVM_GET_CLOCK. The later gives both realtime and kvmclock so guest's epoch
can be calculated by subtraction. Note, the computed epoch may still differ
a few nanoseconds from shinfo as different TSC is used and there are
rounding errors but 100 nanoseconds margin should be enough to cover
it (famous last words).

Reported-by: Jan Richter <jarichte@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/x86_64/xen_shinfo_test.c    | 36 ++++++++-----------
 1 file changed, 14 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index 9ec9ab60b63e..5e1ad243d95d 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -375,20 +375,6 @@ static void guest_code(void)
 	GUEST_SYNC(TEST_DONE);
 }
 
-static int cmp_timespec(struct timespec *a, struct timespec *b)
-{
-	if (a->tv_sec > b->tv_sec)
-		return 1;
-	else if (a->tv_sec < b->tv_sec)
-		return -1;
-	else if (a->tv_nsec > b->tv_nsec)
-		return 1;
-	else if (a->tv_nsec < b->tv_nsec)
-		return -1;
-	else
-		return 0;
-}
-
 static struct vcpu_info *vinfo;
 static struct kvm_vcpu *vcpu;
 
@@ -425,7 +411,6 @@ static void *juggle_shinfo_state(void *arg)
 
 int main(int argc, char *argv[])
 {
-	struct timespec min_ts, max_ts, vm_ts;
 	struct kvm_xen_hvm_attr evt_reset;
 	struct kvm_vm *vm;
 	pthread_t thread;
@@ -443,8 +428,6 @@ int main(int argc, char *argv[])
 	bool do_eventfd_tests = !!(xen_caps & KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL);
 	bool do_evtchn_tests = do_eventfd_tests && !!(xen_caps & KVM_XEN_HVM_CONFIG_EVTCHN_SEND);
 
-	clock_gettime(CLOCK_REALTIME, &min_ts);
-
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
 	/* Map a region for the shared_info page */
@@ -969,7 +952,6 @@ int main(int argc, char *argv[])
 	vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &evt_reset);
 
 	alarm(0);
-	clock_gettime(CLOCK_REALTIME, &max_ts);
 
 	/*
 	 * Just a *really* basic check that things are being put in the
@@ -978,11 +960,16 @@ int main(int argc, char *argv[])
 	 */
 	struct pvclock_wall_clock *wc;
 	struct pvclock_vcpu_time_info *ti, *ti2;
+	struct kvm_clock_data kcdata;
+	long long delta;
 
 	wc = addr_gpa2hva(vm, SHINFO_REGION_GPA + 0xc00);
 	ti = addr_gpa2hva(vm, SHINFO_REGION_GPA + 0x40 + 0x20);
 	ti2 = addr_gpa2hva(vm, PVTIME_ADDR);
 
+	vm_ioctl(vm, KVM_GET_CLOCK, &kcdata);
+	delta = (wc->sec * NSEC_PER_SEC + wc->nsec) - (kcdata.realtime - kcdata.clock);
+
 	if (verbose) {
 		printf("Wall clock (v %d) %d.%09d\n", wc->version, wc->sec, wc->nsec);
 		printf("Time info 1: v %u tsc %" PRIu64 " time %" PRIu64 " mul %u shift %u flags %x\n",
@@ -991,14 +978,19 @@ int main(int argc, char *argv[])
 		printf("Time info 2: v %u tsc %" PRIu64 " time %" PRIu64 " mul %u shift %u flags %x\n",
 		       ti2->version, ti2->tsc_timestamp, ti2->system_time, ti2->tsc_to_system_mul,
 		       ti2->tsc_shift, ti2->flags);
+		printf("KVM_GET_CLOCK realtime: %lld.%09lld\n", kcdata.realtime / NSEC_PER_SEC,
+		       kcdata.realtime % NSEC_PER_SEC);
+		printf("KVM_GET_CLOCK clock: %lld.%09lld\n", kcdata.clock / NSEC_PER_SEC,
+		       kcdata.clock % NSEC_PER_SEC);
 	}
 
-	vm_ts.tv_sec = wc->sec;
-	vm_ts.tv_nsec = wc->nsec;
 	TEST_ASSERT(wc->version && !(wc->version & 1),
 		    "Bad wallclock version %x", wc->version);
-	TEST_ASSERT(cmp_timespec(&min_ts, &vm_ts) <= 0, "VM time too old");
-	TEST_ASSERT(cmp_timespec(&max_ts, &vm_ts) >= 0, "VM time too new");
+
+	TEST_ASSERT(llabs(delta) < 100,
+		    "Guest's epoch from shinfo %d.%09d differs from KVM_GET_CLOCK %lld.%lld",
+		    wc->sec, wc->nsec, (kcdata.realtime - kcdata.clock) / NSEC_PER_SEC,
+		    (kcdata.realtime - kcdata.clock) % NSEC_PER_SEC);
 
 	TEST_ASSERT(ti->version && !(ti->version & 1),
 		    "Bad time_info version %x", ti->version);
-- 
2.43.0


