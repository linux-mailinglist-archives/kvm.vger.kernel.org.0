Return-Path: <kvm+bounces-48221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 88A3EACBD75
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 00:45:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A7F1B18923DE
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 22:45:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 835DB25394F;
	Mon,  2 Jun 2025 22:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a66cYZRA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15579253931
	for <kvm@vger.kernel.org>; Mon,  2 Jun 2025 22:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748904305; cv=none; b=ZgQWRI4UBOUo5jpoV0cJyCnpqynFaq+UkATODPwMQicsSclkVxeiS7mccX5ZPr2NOHxTrdPhpHKfTXHbbPdHFIJmkc64hxT6GUup8AD0+VAanTYt+AJQddoTSTeAr4F/M8jBJZj2hMFGCymx2Rr7UPZgt1quzAainws6YLPTqQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748904305; c=relaxed/simple;
	bh=I5LVv4PewaQ6DtCG3zdvrtnRt8RigUtPSJw9yr8Po5A=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Lph7T8hmb82sN6j4brgvyaFyUpLJtTHPxg1UdMnfHQlgFbHedYwfkSqyqXSU4kB2qiZ2wA4MHlH13+fuyuuZhS7yE91FOqFRSbFYmaizJwrmwuMrYLIH+7SMV7IEqd27bKLlVWQd8ZBuGnuSR/7LHpxmcMRVnf2eRkcxqbwNN2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a66cYZRA; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b19226b5f7dso3393502a12.0
        for <kvm@vger.kernel.org>; Mon, 02 Jun 2025 15:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748904303; x=1749509103; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SsDaMA7oWVnIs9uJw3iLXML/vryw4vXt2o9HAQy0APo=;
        b=a66cYZRAAbPYO0gZ/OGJNUvQr81E6EEBTLw4qtuadGGNkhSh4czqaKm1AsdSfbns8Q
         xvdruLecYUI+FgU5gcCmQM/wn+2gpRXlPe4DvLLKOtEe7bhklFPd+cF4ug8CLMYUvWYd
         p1toI1KiIXgdmI/eeYPgriRez4r7h/0RFTvMP7buttN/y/GXrKIGKCPY/ol5dEx7j3sM
         u4QAW3pVE9pxCoQM9ixTc58NHU7D2AJG3Fxb5chnAMR14t+Ad8tH+fp/c3e/IEXcK55h
         WVkL3Yxl4XyPAjrNSYZJ1pNXOXUg5kgwrkLje3LNSZDt2S4ykp5Qfa1kVBnd0NmqzOoz
         iavA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748904303; x=1749509103;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SsDaMA7oWVnIs9uJw3iLXML/vryw4vXt2o9HAQy0APo=;
        b=PaMz+9ckQNOAr+Acshx2e6tfKpGcPQpJtochDnsZScEfbcJ9gh9gn/WXg/iBUIQr1k
         wPOobhMO31Fv1VOV6z68vTuF5CvjkPw/aiMN/Sk7+eMFVZbYa4VbzhNtznfp7c1IB2hk
         0XnUkK4fMqgAUAjcbt5LzZ7ucQLo9HX3Bi0k7xoXuBtls63+ApXO+H4pvS+Hz0eerSjY
         8bpx/uJKO3Nox3ZHEPN7V8vemzsHzlwj8Zu8OQjIdcpmw9JEI1dYhWk2aEW2LXvqdHl4
         zi3xSGVgyqMIF01tAAh6EgjRJ9FQoNYLTD3JUWkzPYOndPFnYZD5uQHPVri404ZiVpAX
         FiUw==
X-Gm-Message-State: AOJu0YzRQlL/rxfpgJ9XZDwcLw1B0SfYojT3bG/hQPlANl+Cs2Fs9MY2
	3+Osq7T1ihPBXN2v7U6ltdWgl6gXMHrfg63+3QlSA/zWSR2J08kouwQmZE04cnfwiMnX77t5MzT
	QJ/ra3w==
X-Google-Smtp-Source: AGHT+IHWHeSRJMTamHT6ZxF330LmZvg3PoU+UEjDkaSuRzaoT0dOs++4ccqfRZ9ngn9ssu6oOYgryEt6x/Q=
X-Received: from pjbpw16.prod.google.com ([2002:a17:90b:2790:b0:311:d1a5:3818])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:274a:b0:311:abba:53b6
 with SMTP id 98e67ed59e1d1-312e81bf285mr379772a91.14.1748904303336; Mon, 02
 Jun 2025 15:45:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon,  2 Jun 2025 15:44:57 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250602224459.41505-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: SVM: Fix a NULL VMSA deref with MOVE_ENC_CONTEXT
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Alexander Potapenko <glider@google.com>, James Houghton <jthoughton@google.com>, 
	Peter Gonda <pgonda@google.com>, Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"

Fix a NULL VMSA deref bug (which is probably the tip of the iceberg with
respect to what all can go wrong) due to a race between KVM_CREATE_VCPU and
KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM, where a non-SEV-ES vCPU can be created in
an SEV-ES VM.

Found by running syzkaller on a bare metal SEV-ES host.  C repro below.

Sean Christopherson (2):
  KVM: SVM: Reject SEV{-ES} intra host migration if vCPU creation is
    in-flight
  KVM: SVM: Initialize vmsa_pa in VMCB to INVALID_PAGE if VMSA page is
    NULL

 arch/x86/kvm/svm/sev.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)


base-commit: 0ff41df1cb268fc69e703a08a57ee14ae967d0ca
-- 
2.49.0.1204.g71687c7c1d-goog

// autogenerated by syzkaller (https://github.com/google/syzkaller)

#define _GNU_SOURCE

#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <pthread.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/syscall.h>
#include <sys/wait.h>

#include <linux/futex.h>
#include <linux/kvm.h>

static unsigned long long procid;

static void sleep_ms(uint64_t ms)
{
  usleep(ms * 1000);
}

static uint64_t current_time_ms(void)
{
  struct timespec ts;
  if (clock_gettime(CLOCK_MONOTONIC, &ts))
    exit(1);
  return (uint64_t)ts.tv_sec * 1000 + (uint64_t)ts.tv_nsec / 1000000;
}

static void thread_start(void* (*fn)(void*), void* arg)
{
  pthread_t th;
  pthread_attr_t attr;
  pthread_attr_init(&attr);
  pthread_attr_setstacksize(&attr, 128 << 10);
  int i = 0;
  for (; i < 100; i++) {
    if (pthread_create(&th, &attr, fn, arg) == 0) {
      pthread_attr_destroy(&attr);
      return;
    }
    if (errno == EAGAIN) {
      usleep(50);
      continue;
    }
    break;
  }
  exit(1);
}

typedef struct {
  int state;
} event_t;

static void event_init(event_t* ev)
{
  ev->state = 0;
}

static void event_reset(event_t* ev)
{
  ev->state = 0;
}

static void event_set(event_t* ev)
{
  if (ev->state)
    exit(1);
  __atomic_store_n(&ev->state, 1, __ATOMIC_RELEASE);
  syscall(SYS_futex, &ev->state, FUTEX_WAKE | FUTEX_PRIVATE_FLAG, 1000000);
}

static void event_wait(event_t* ev)
{
  while (!__atomic_load_n(&ev->state, __ATOMIC_ACQUIRE))
    syscall(SYS_futex, &ev->state, FUTEX_WAIT | FUTEX_PRIVATE_FLAG, 0, 0);
}

static int event_isset(event_t* ev)
{
  return __atomic_load_n(&ev->state, __ATOMIC_ACQUIRE);
}

static int event_timedwait(event_t* ev, uint64_t timeout)
{
  uint64_t start = current_time_ms();
  uint64_t now = start;
  for (;;) {
    uint64_t remain = timeout - (now - start);
    struct timespec ts;
    ts.tv_sec = remain / 1000;
    ts.tv_nsec = (remain % 1000) * 1000 * 1000;
    syscall(SYS_futex, &ev->state, FUTEX_WAIT | FUTEX_PRIVATE_FLAG, 0, &ts);
    if (__atomic_load_n(&ev->state, __ATOMIC_ACQUIRE))
      return 1;
    now = current_time_ms();
    if (now - start > timeout)
      return 0;
  }
}

struct thread_t {
  int created, call;
  event_t ready, done;
};

static struct thread_t threads[16];
static void execute_call(int call);
static int running;

static void* thr(void* arg)
{
  struct thread_t* th = (struct thread_t*)arg;
  for (;;) {
    event_wait(&th->ready);
    event_reset(&th->ready);
    execute_call(th->call);
    __atomic_fetch_sub(&running, 1, __ATOMIC_RELAXED);
    event_set(&th->done);
  }
  return 0;
}

static void execute_one(void)
{
  if (write(1, "executing program\n", sizeof("executing program\n") - 1)) {
  }
  int i, call, thread;
  for (call = 0; call < 9; call++) {
    for (thread = 0; thread < (int)(sizeof(threads) / sizeof(threads[0]));
         thread++) {
      struct thread_t* th = &threads[thread];
      if (!th->created) {
        th->created = 1;
        event_init(&th->ready);
        event_init(&th->done);
        event_set(&th->done);
        thread_start(thr, th);
      }
      if (!event_isset(&th->done))
        continue;
      event_reset(&th->done);
      th->call = call;
      __atomic_fetch_add(&running, 1, __ATOMIC_RELAXED);
      event_set(&th->ready);
      if (call == 2 || call == 5 || call == 7)
        break;
      event_timedwait(&th->done, 50);
      break;
    }
  }
  for (i = 0; i < 100 && __atomic_load_n(&running, __ATOMIC_RELAXED); i++)
    sleep_ms(1);
}

static void loop(void)
{
  int iter = 0;
  for (; iter < 100; iter++) {
    int pid = fork();
    if (pid < 0)
      exit(1);
    if (pid == 0) {
      execute_one();
      exit(0);
    }
    int status = 0;
    uint64_t start = current_time_ms();
    for (;;) {
      sleep_ms(10);
      if (waitpid(-1, &status, WNOHANG | __WALL) == pid)
        break;
      if (current_time_ms() - start < 5000)
        continue;
      break;
    }
  }
}

uint64_t r[4] = {0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff,
                 0xffffffffffffffff};

void execute_call(int call)
{
  switch (call) {
  case 0:
    r[1] = syscall(__NR_ioctl, /*fd=*/r[0], /*cmd=*/KVM_CREATE_VM, /*type=*/0ul);
    break;
  case 3:
    r[3] = syscall(__NR_ioctl, /*fd=*/r[0], /*cmd=*/KVM_CREATE_VM, /*type=*/0ul);
    break;
  case 5:
    syscall(__NR_ioctl, /*fd=*/r[3], /*cmd=*/KVM_CREATE_VCPU, /*id=*/0ul);
    for (int i = 0; i < 32; i++) {
      syscall(__NR_ioctl, /*fd=*/r[3], /*cmd=*/KVM_CREATE_VCPU, /*id=*/0ul);
    }
    break;
  case 6:
    *(uint64_t*)0x200000000040 = 1;
    *(uint32_t*)0x200000000048 = 8;
    *(uint32_t*)0x20000000004c = 0;
    *(uint64_t*)0x200000000050 = 0x5625e9b0;
    *(uint64_t*)0x200000000058 = 0;
    memset((void*)0x200000000060, 0, 16);
    syscall(__NR_ioctl, /*fd=*/r[1], /*cmd=*/KVM_MEMORY_ENCRYPT_OP,
            /*arg=*/0x200000000040ul);
    for (int i = 0; i < 32; i++) {
      syscall(__NR_ioctl, /*fd=*/r[1], /*cmd=*/KVM_MEMORY_ENCRYPT_OP,
              /*arg=*/0x200000000040ul);
    }
    break;
  case 7:
    *(uint32_t*)0x200000000080 = KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM;
    *(uint32_t*)0x200000000084 = 0;
    *(uint32_t*)0x200000000088 = r[1];
    syscall(__NR_ioctl, /*fd=*/r[3], /*cmd=*/KVM_ENABLE_CAP,
            /*arg=*/0x200000000080ul);
    break;
  }
}
int main(void)
{
  syscall(__NR_mmap, /*addr=*/0x1ffffffff000ul, /*len=*/0x1000ul, /*prot=*/0ul,
          /*flags=MAP_FIXED|MAP_ANONYMOUS|MAP_PRIVATE*/ 0x32ul,
          /*fd=*/(intptr_t)-1, /*offset=*/0ul);
  syscall(__NR_mmap, /*addr=*/0x200000000000ul, /*len=*/0x1000000ul,
          /*prot=PROT_WRITE|PROT_READ|PROT_EXEC*/ 7ul,
          /*flags=MAP_FIXED|MAP_ANONYMOUS|MAP_PRIVATE*/ 0x32ul,
          /*fd=*/(intptr_t)-1, /*offset=*/0ul);
  syscall(__NR_mmap, /*addr=*/0x200001000000ul, /*len=*/0x1000ul, /*prot=*/0ul,
          /*flags=MAP_FIXED|MAP_ANONYMOUS|MAP_PRIVATE*/ 0x32ul,
          /*fd=*/(intptr_t)-1, /*offset=*/0ul);
  for (procid = 0; procid < 10; procid++) {
    if (fork() == 0) {
      r[0] = open("/dev/kvm", O_RDWR);
      loop();
    }
  }
  sleep(1000000);
  return 0;
}

