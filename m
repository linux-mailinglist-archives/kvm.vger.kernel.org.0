Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A68FA46446D
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 02:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345925AbhLABL0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 20:11:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbhLABLU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 20:11:20 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7795C061746
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 17:08:00 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id 133so3592936pgc.12
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 17:08:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vbRT8aXA3F1xt3PU8F3O8agTqIaZlbDpUx5b8CZCQKY=;
        b=fT5iWAGZX+tpuhGkx/az1x5XGClubCRCkpS/kkCJTV1/53Yx3PUbOe9L1df2WtXSt+
         AKZKjPqXgpiF2ya71hO4+ewV37JU7xx461fYNP5jIyMNyADtvVLswuURNf5mFl+xUagL
         CN0eMhGMZo9pv7hYyCr/dOc8QKCASC00WIXlKcr0bW0ET7iatUb7Ohd7QylxEPJHtjLq
         TbQZiZndthKKq7i+qvfI0urd1fUyR6xgl0YDaybr0kL7I7LCuE1jnIGOOj5+IADI5hy1
         v2D0EnTLgVmNjW1SkQczO1tTXivxHClJnpgKUHiPqwN+0SWyEGRjNJWP0btYog4LBEUN
         KZxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vbRT8aXA3F1xt3PU8F3O8agTqIaZlbDpUx5b8CZCQKY=;
        b=QAajVAe/CCG7ZWS1eF9KggOxswcPperdkBZkp8YS1ydUpqEMx/NsuCONdULuGelMGi
         UDiL5avG/Z2ljaCdg/CQN2i663TbNeS9GX508nHhYGACDdHwHR8PRhomUXsi9dX4ZUcj
         et6ugk0QboUaQLm0RpzXlaku4QpvbMNhGoEcfSRWe6nVUH4iUGUuUZakupu2aHxrl1Ig
         dK9tN5Un84KZm7Cnzk/dgdekSVKp4Zn+3cFdwCSCSxDxAGhc2uE5RqHPHy2d3Mnyt9Yq
         YFJWIZHocRdvfwo0plkL6p5t63YeHRt4a+5HqtUI9yB2191ATxA/H401eBTonJaC2HeE
         LQkw==
X-Gm-Message-State: AOAM531ZyrsAC/tHnUnPwmVYRtLFbRznp09+ZN78WOB9J1OIrx2MMSHY
        dHjNV+Eb+iKT4divJPgfDBVzcw==
X-Google-Smtp-Source: ABdhPJzC1qeyr70CZme3ye39kJgvSth76594RljQ4Bv+NT1siBBapSHrb4rL7Ge5ghX0RunE32HUpw==
X-Received: by 2002:a05:6a00:2349:b0:4a8:d87:e8ad with SMTP id j9-20020a056a00234900b004a80d87e8admr2962268pfj.15.1638320880128;
        Tue, 30 Nov 2021 17:08:00 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m24sm15869121pgk.39.2021.11.30.17.07.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 17:07:59 -0800 (PST)
Date:   Wed, 1 Dec 2021 01:07:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 03/29] KVM: Resync only arch fields when
 slots_arch_lock gets reacquired
Message-ID: <YabK7IOM74ag2CcS@google.com>
References: <cover.1638304315.git.maciej.szmigiero@oracle.com>
 <a47c93c2fe40e7ed27eb0ff6ac2b173254058b6c.1638304315.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a47c93c2fe40e7ed27eb0ff6ac2b173254058b6c.1638304315.git.maciej.szmigiero@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 30, 2021, Maciej S. Szmigiero wrote:
> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> There is no need to copy the whole memslot data after releasing
> slots_arch_lock for a moment to install temporary memslots copy in
> kvm_set_memslot() since this lock only protects the arch field of each
> memslot.
> 
> Just resync this particular field after reacquiring slots_arch_lock.
> 
> Note, this also eliminates the need to manually clear the INVALID flag
> when restoring memslots; the "setting" of the INVALID flag was an
> unwanted side effect of copying the entire memslots.
> 
> Since kvm_copy_memslots() has just one caller remaining now
> open-code it instead.
> 
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> [sean: tweak shortlog, note INVALID flag in changelog, revert comment]
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Heh, I think you can drop my SoB?  This is new territory for me, I don't know the
rules for this particular situation.

Reviewed-by: Sean Christopherson <seanjc@google.com>
