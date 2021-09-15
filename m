Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14B7440CF0E
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 23:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbhIOV4h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 17:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbhIOV4f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Sep 2021 17:56:35 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 662C9C061574
        for <kvm@vger.kernel.org>; Wed, 15 Sep 2021 14:55:15 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id b200so5392448iof.13
        for <kvm@vger.kernel.org>; Wed, 15 Sep 2021 14:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nBrJ+himGBxxi4AYbh7qI25DuiLu4lSxjn/yGNO9s04=;
        b=mtre4tgf60/KeYM+tgme6BjszuZBTn4nWSGxuGAQqi3zN29JTf4sUc1+cmjcb7UAlk
         G2FlxBug7tJlqAowsOnxmGhegd5Fu0FVSdi9lcoikegRf7e8rlwaZFgIReJrIdXNuQiQ
         BpktZtfb/MQ4aLbvJZeFPnJNN89W7hOb3YeGx5BoGNwYT2vaZJr7MJYwpPUv+VhzF0lK
         FwjoKR5vAvey+wFsKnrFKFY+cgXu62Q9YfmrC17OSHZcegPg1l7U5WsdjK8A83d8AmJc
         Ct3rwvTsCmAvdbqfIVN5wTe2DycLOyLJsCe1cJnC5FqzP72x2EdBYDjfsTXajTXh5iyJ
         yEOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nBrJ+himGBxxi4AYbh7qI25DuiLu4lSxjn/yGNO9s04=;
        b=JR/4/17elyeiUgjdRsR1IINVx8XeX4uD0u+9kwpnbrHzmbfmSFRdAf8H2wclmWhF/7
         g9ZLA795hYVuXmq+AWhpkcqOJo4W3UOesa2fk+xJHioVpqWQLlycntLTt/jop9a/0yDd
         n0qaGLr5ZGKtTtYDnCa4yuxI991aJOl2dVsTHp//nB0hgWmFdg28hDbMswevoZLhsFO1
         SVQym0bBQL5unKdcmN3clAv1q3GgxRaVjjfcUFKBhmB/CGEnAwhtrzWDL1ErypnMFOW/
         PZ8cUGtcOImYfZ0rkEN0/UFtFGet6FMnfjXgrzltMPulrQqmx/U2DLMPTNy4B6OdrPIZ
         De7w==
X-Gm-Message-State: AOAM532T1ysmnyZOHfXsHl+Dr/5v5djDKetQs7JowEVHswRC2wL4rl0r
        83F4Px/VZCY140sFhiuo4N7E5ASP+uLeKiLrgAuEZGEhdo4=
X-Google-Smtp-Source: ABdhPJxmwekqDWWSm390j9zcfEfsiu+UvHo2wMFvO40obck7jVBl72HBNGa9L6nQSxfbieTzlHOpt6/RJ27adpwC2so=
X-Received: by 2002:a6b:ba42:: with SMTP id k63mr1784616iof.37.1631742914594;
 Wed, 15 Sep 2021 14:55:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210915213034.1613552-1-dmatlack@google.com> <20210915213034.1613552-4-dmatlack@google.com>
In-Reply-To: <20210915213034.1613552-4-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 15 Sep 2021 14:55:03 -0700
Message-ID: <CANgfPd_WkrdXJ3qYmv_DKLbKDsNs8KJK4i9sX3+kR_cwNmbJ_w@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: selftests: Fix dirty bitmap offset calculation
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yanan Wang <wangyanan55@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 15, 2021 at 2:30 PM David Matlack <dmatlack@google.com> wrote:
>
> The calculation to get the per-slot dirty bitmap was incorrect leading
> to a buffer overrun. Fix it by dividing the number of pages by
> BITS_PER_LONG, since each element of the bitmap is a long and there is
> one bit per page.
>
> Fixes: 609e6202ea5f ("KVM: selftests: Support multiple slots in dirty_log_perf_test")
> Signed-off-by: David Matlack <dmatlack@google.com>

I was a little confused initially because we're allocating only one
dirty bitmap in userspace even when we have multiple slots, but that's
not a problem.

Reviewed-by: Ben Gardon <bgardon@google.com>


>
> ---
>  tools/testing/selftests/kvm/dirty_log_perf_test.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index 5ad9f2bc7369..0dd4626571e9 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -118,6 +118,12 @@ static inline void disable_dirty_logging(struct kvm_vm *vm, int slots)
>         toggle_dirty_logging(vm, slots, false);
>  }
>
> +static unsigned long *get_slot_bitmap(unsigned long *bitmap, uint64_t page_offset)
> +{
> +       /* Guaranteed to be evenly divisible by the TEST_ASSERT in run_test. */
> +       return &bitmap[page_offset / BITS_PER_LONG];
> +}
> +
>  static void get_dirty_log(struct kvm_vm *vm, int slots, unsigned long *bitmap,
>                           uint64_t nr_pages)
>  {
> @@ -126,7 +132,8 @@ static void get_dirty_log(struct kvm_vm *vm, int slots, unsigned long *bitmap,
>
>         for (i = 0; i < slots; i++) {
>                 int slot = PERF_TEST_MEM_SLOT_INDEX + i;
> -               unsigned long *slot_bitmap = bitmap + i * slot_pages;
> +               uint64_t page_offset = slot_pages * i;
> +               unsigned long *slot_bitmap = get_slot_bitmap(bitmap, page_offset);
>
>                 kvm_vm_get_dirty_log(vm, slot, slot_bitmap);
>         }
> @@ -140,7 +147,8 @@ static void clear_dirty_log(struct kvm_vm *vm, int slots, unsigned long *bitmap,
>
>         for (i = 0; i < slots; i++) {
>                 int slot = PERF_TEST_MEM_SLOT_INDEX + i;
> -               unsigned long *slot_bitmap = bitmap + i * slot_pages;
> +               uint64_t page_offset = slot_pages * i;
> +               unsigned long *slot_bitmap = get_slot_bitmap(bitmap, page_offset);
>
>                 kvm_vm_clear_dirty_log(vm, slot, slot_bitmap, 0, slot_pages);
>         }
> @@ -172,6 +180,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>         guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
>         host_num_pages = vm_num_host_pages(mode, guest_num_pages);
>         bmap = bitmap_alloc(host_num_pages);
> +       TEST_ASSERT((host_num_pages / p->slots) % BITS_PER_LONG == 0,
> +                   "The number of pages per slot must be divisible by %d.",
> +                   BITS_PER_LONG);
>
>         if (dirty_log_manual_caps) {
>                 cap.cap = KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2;
> --
> 2.33.0.309.g3052b89438-goog
>
