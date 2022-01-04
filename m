Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3C2483FF6
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 11:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbiADKds (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 05:33:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56249 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229731AbiADKds (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Jan 2022 05:33:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641292427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=16eehyGiNBcSXKxjBk8zjAEdV2qfJ7jdrT5+W7Fv48Q=;
        b=X0lk1kQ34xtHbjOBDhJTJS7lVQ4rir5WfAg3SQ7H5GYOkj1Icj3tm7lIGtnY0qz5ceb1C7
        wWaj8geZnq0PBloqvVsNyf2AwXzSSeGgTml8cz8zZBxY48LtmIa7Rhb8i/Eu07bafY9PEp
        c2fD0Lz3n9yDQURLaJ7TMZYpdQGSDWo=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-570-GB7NA0lBOXayS0uh3eBjyQ-1; Tue, 04 Jan 2022 05:33:46 -0500
X-MC-Unique: GB7NA0lBOXayS0uh3eBjyQ-1
Received: by mail-pg1-f200.google.com with SMTP id t1-20020a6564c1000000b002e7f31cf59fso19551672pgv.14
        for <kvm@vger.kernel.org>; Tue, 04 Jan 2022 02:33:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=16eehyGiNBcSXKxjBk8zjAEdV2qfJ7jdrT5+W7Fv48Q=;
        b=bnR5BWtA+fkATUgre6rSmZUQqQrn9+umLHUjWtJ99mToxZwgALsKFtbpX0gvA3l1j3
         duC/wBIZ8WUbWmbKqLWsj18q8+gZ3FX9kJetjMzWIvpzgaX+1XliQW4TihY1xn43R4ag
         c5ttaL+1CwbMfEiGpeHl3t103a0lrCO/qufG+voJQFA+E2Tb4NuYnK+0g8dLGNAdt/Fq
         L3om4rfQ+F7pTVMiLp0OB2B9tXmAkLTFj9vOVNJxZCSNKR8wNVCGT++joChxyeMCRoBV
         u4CLHoA9Whu9WuI5X87lkleNWi3VASGhWd/7VOLHRRcXc+ow2+bg06g7sBTRErAb/lQM
         Czew==
X-Gm-Message-State: AOAM533XyF2y+hWtxaddykzrraBEQK/9zr3LdNK0jcOF1PkSa3SO6VQX
        4phpBASwxL4q1/9KfTmUIifdKotuZmPzLd2Cyeh075yYOj0DdG88SX8fcFfhMVShxgeFTwy9DuN
        1YbrlgnKuDm8H
X-Received: by 2002:a63:b914:: with SMTP id z20mr44035597pge.496.1641292425481;
        Tue, 04 Jan 2022 02:33:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJye7zCpqJccgdt4G5Rt1u/+TGbE+8W6D5gi4jZ+ozANGKz2h5GGbtIjBHoCY6wzLYSRjZdYaw==
X-Received: by 2002:a63:b914:: with SMTP id z20mr44035577pge.496.1641292425231;
        Tue, 04 Jan 2022 02:33:45 -0800 (PST)
Received: from xz-m1.local ([191.101.132.50])
        by smtp.gmail.com with ESMTPSA id s8sm18766084pfu.190.2022.01.04.02.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 02:33:44 -0800 (PST)
Date:   Tue, 4 Jan 2022 18:33:37 +0800
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>
Subject: Re: [PATCH v1 05/13] KVM: x86/mmu: Move restore_acc_track_spte to
 spte.c
Message-ID: <YdQigWj1yh63Yv4p@xz-m1.local>
References: <20211213225918.672507-1-dmatlack@google.com>
 <20211213225918.672507-6-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211213225918.672507-6-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 13, 2021 at 10:59:10PM +0000, David Matlack wrote:
> restore_acc_track_spte is purely an SPTE manipulation, making it a good
> fit for spte.c. It is also needed in spte.c in a follow-up commit so we
> can construct child SPTEs during large page splitting.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> Reviewed-by: Ben Gardon <bgardon@google.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

