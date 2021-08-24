Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10BD73F6AE8
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 23:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234723AbhHXVPz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 17:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233774AbhHXVPy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 17:15:54 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12917C061757
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 14:15:10 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id l10so8163391ilh.8
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 14:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=ahx89PC8cIKRx7Tmgj3ezIoGMxGJS6rYJPfdg8hea3I=;
        b=Blewoeg8VpEAOSLu2fSVu1OYBII8wSOT80G8mkJfn17EhHJTy8t0VNwi1CMA35qzJH
         PRNMksekGBMvfEDa3qJe36pT4LdGCE1FTxqod0mR6XTiXTCpxXoj2DP+T3e1Oru5MOM+
         SeTcPAMWPYLnbKsWsLQAoBsq+L6rzQVil6UYcvCVGis77NysmIW+IIDOCT9829zPy+ZM
         HNSI4par/xzky/hnonF2H6lYrlRgUfMLLTvc5agLCJSH3L8ooyfq+b7JZRgqLbrSBTlT
         VR1NetWEkKhWRrdPCcXEAo3AFp8CsjP+AWP/HzqUmOPxnNQojfwhKj62gyWzJC0/tDlZ
         EkfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=ahx89PC8cIKRx7Tmgj3ezIoGMxGJS6rYJPfdg8hea3I=;
        b=BNzKt8TMjHR5oPU8ePDtdMy0hB7jmQ4hW+UlttENOtFPvdK65mALr5sBSUjlg1pdUs
         M1MPRxTbGc660qJ2PvFQG0sBh6U0mIACLdmcgI9XvT8x2YU6f2/RBsLO4WVWd/gunYmw
         LW7RCLTzZstErvcrVSQp7lAbxOPEEQjsqaN3naY2EbfPqDWdABFu2NcPKm8vdVUtH023
         oINeb+kTsfOT9MJDQYWAW1N/igk7IU0ofjzsnPtDnQQSnixzEJ5vG+B2JhQyfYYK4HIk
         ku1yNvQEIsr48iFRh+ByyWO/j4T/t8elOsOQ7mdQ6P3+E6adeiT8Vzx7vovYhafJSiIM
         0zeg==
X-Gm-Message-State: AOAM533p42rWOHy9DLjgUCs5uLxUkBjsV8RVV/tb8M40SwrmTsHrKzUN
        iGN7DO8mXktgWi0IR4arnnzwHw==
X-Google-Smtp-Source: ABdhPJzYkTLe3JL/GRn7dx88lWcWUrTlT/x7EdbbtUTbRMUsj0b7GHuF0etxTSoOuXH25YUqoAlx3g==
X-Received: by 2002:a92:d282:: with SMTP id p2mr24901934ilp.259.1629839709100;
        Tue, 24 Aug 2021 14:15:09 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id z7sm10585059ilz.25.2021.08.24.14.15.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 14:15:08 -0700 (PDT)
Date:   Tue, 24 Aug 2021 21:15:03 +0000
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, pshier@google.com, ricarkol@google.com,
        rananta@google.com, reijiw@google.com, jingzhangos@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com
Subject: KVM/arm64: Guest ABI changes do not appear rollback-safe
Message-ID: <YSVhV+UIMY12u2PW@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey folks,

Ricardo and I were discussing hypercall support in KVM/arm64 and
something seems to be a bit problematic. I do not see anywhere that KVM
requires opt-in from the VMM to expose new hypercalls to the guest. To
name a few, the TRNG and KVM PTP hypercalls are unconditionally provided
to the guest.

Exposing new hypercalls to guests in this manner seems very unsafe to
me. Suppose an operator is trying to upgrade from kernel N to kernel
N+1, which brings in the new 'widget' hypercall. Guests are live
migrated onto the N+1 kernel, but the operator finds a defect that
warrants a kernel rollback. VMs are then migrated from kernel N+1 -> N.
Any guests that discovered the 'widget' hypercall are likely going to
get fussy _very_ quickly on the old kernel.

Really, we need to ensure that the exposed guest ABI is
backwards-compatible. Running a VMM that is blissfully unaware of the
'widget' hypercall should not implicitly expose it to its guest on a new
kernel.

This conversation was in the context of devising a new UAPI that allows
VMMs to trap hypercalls to userspace. While such an interface would
easily work around the issue, the onus of ABI compatibility lies with
the kernel.

So, this is all a long-winded way of asking: how do we dig ourselves out
of this situation, and how to we avoid it happening again in the future?
I believe the answer to both is to have new VM capabilities for sets of
hypercalls exposed to the guest. Unfortunately, the unconditional
exposure of TRNG and PTP hypercalls is ABI now, so we'd have to provide
an opt-out at this point. For anything new, require opt-in from the VMM
before we give it to the guest.

Have I missed something blatantly obvious, or do others see this as an
issue as well? I'll reply with an example of adding opt-out for PTP.
I'm sure other hypercalls could be handled similarly.

--
Thanks,
Oliver
