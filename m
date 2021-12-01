Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA9E4644D8
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 03:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346029AbhLACZH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 21:25:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345957AbhLACZF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 21:25:05 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05AFAC061746
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 18:21:46 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so19785174pju.3
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 18:21:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gie1EwZxonCzFvugUYBX8WOXYkfnwgMVP4++lOOlv+c=;
        b=BHHWYuF18555l0y3u6rGa+kEPLUpRnTak219rl+ifA1BegpvG+NBgLb0it0I4y1PBo
         opX2RyrCSzAxdaDMxLHZgYuQBb3UVPD2vfYENDpOiOvKud4gngvK2ESBdq2wzO7bvYFs
         Uom+60iWQDBpxbmPU70HUiBcp58Q+IzMSy+kvlJ0vEJ1p8v4tuSDuU8pkpbNTFB618qG
         GRyKbd/AR+lkFA4jCgEvLeAjD26ZWOnk3TJw1kKRu0Qd77in9KBkimE5/N26zN4jm81l
         dcBG7UIm2ufF53HRCOZW7kupF9U+VKWo5L41OJTTQxhPRxp8ZLBeqKPhTwxyhB0gaVmZ
         Kypw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gie1EwZxonCzFvugUYBX8WOXYkfnwgMVP4++lOOlv+c=;
        b=dmJdTO/siK+hCdiWmurxO9ZHDm9U4utoiGY8o8gKKFUJyPM15Pu0SzY70k/CNZ8uV6
         dV89jsJidFkDIqLWWXMp8dnGDevGms5rLe+IDdlQc2JYPzJhBSaKxG+SDkRbT8BMgVDA
         1X+ZHyUF4nRsBjikmSDNixKdoRarG7RmIJw59ZJOC6z0Q9BvLweENIzlkdUqsTeQXNOq
         Sr1e2DBrOVWp3Tzt1vZo32Li3Jf33rT9hkykRPaJksa/uwURGslkGoz9DQm0uXAeaRo4
         qw6P+fCjJL7Ba3DmV1+tHt3JjtQ/g1eZBHnXlfbglrrbQN3Mg7si/hFDxft20I7j5ysf
         xDyw==
X-Gm-Message-State: AOAM532xRnFQPABOQ8dfoTiB2QXZ3HZ3vNpGTc1xw0NkU02FNaaDOGS9
        elSZ7By//x6CeLkbTLT9y0fuGw==
X-Google-Smtp-Source: ABdhPJx7ckMHu0ZBbHoG3wVdN35yNz+jTnr/6AkXoHITLna8yQnOkJAuMipyrJqERvLCPmT0P99eUg==
X-Received: by 2002:a17:902:748c:b0:141:c45e:c612 with SMTP id h12-20020a170902748c00b00141c45ec612mr3544713pll.73.1638325305343;
        Tue, 30 Nov 2021 18:21:45 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j13sm21251711pfc.151.2021.11.30.18.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 18:21:44 -0800 (PST)
Date:   Wed, 1 Dec 2021 02:21:41 +0000
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
Subject: Re: [PATCH v6 18/29] KVM: x86: Use nr_memslot_pages to avoid
 traversing the memslots array
Message-ID: <YabcNaCb88s/CTop@google.com>
References: <cover.1638304315.git.maciej.szmigiero@oracle.com>
 <74663af27fd6e25b7846da343f7013b1e9885a4b.1638304316.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74663af27fd6e25b7846da343f7013b1e9885a4b.1638304316.git.maciej.szmigiero@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 30, 2021, Maciej S. Szmigiero wrote:
> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> There is no point in recalculating from scratch the total number of pages
> in all memslots each time a memslot is created or deleted.  Use KVM's
> cached nr_memslot_pages to compute the default max number of MMU pages.
> 
> Note that even with nr_memslot_pages capped at ULONG_MAX we can't safely
> multiply it by KVM_PERMILLE_MMU_PAGES (20) since this operation can
> possibly overflow an unsigned long variable.
> 
> Write this "* 20 / 1000" operation as "/ 50" instead to avoid such
> overflow.
> 
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> [sean: use common KVM field and rework changelog accordingly]
> Signed-off-by: Sean Christopherson <seanjc@google.com>

My SoB can definitely be dropped for this one, just consider it review feedback
that happened to have an SoB attached.

Reviewed-by: Sean Christopherson <seanjc@google.com> 
