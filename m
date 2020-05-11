Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E634B1CE031
	for <lists+kvm@lfdr.de>; Mon, 11 May 2020 18:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730575AbgEKQPL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 May 2020 12:15:11 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26290 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726687AbgEKQPL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 May 2020 12:15:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589213710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hMmg8VXRFHP3NtN5OvlSRCC/9CYursiCkwl7Hbg93g0=;
        b=UcM2L5DBBTShsOTMIDTriHKkzKFhg7Zkbn6FgbSVseu2LVGP6GIcLK2CnjKodb4qjEaE78
        r+gRISeeAT8/p/noO4IGBqZ4pCz9mJuQ3xNor4kcRwz2LQogWmRi2eVoefS1pwA1tcCJhd
        9C1BKRURx3eMR/xozqE4iN0Zx3O3rmI=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-GMRiycZRP0i7uYPGyKieBw-1; Mon, 11 May 2020 12:15:08 -0400
X-MC-Unique: GMRiycZRP0i7uYPGyKieBw-1
Received: by mail-qk1-f199.google.com with SMTP id l4so10571558qke.2
        for <kvm@vger.kernel.org>; Mon, 11 May 2020 09:15:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hMmg8VXRFHP3NtN5OvlSRCC/9CYursiCkwl7Hbg93g0=;
        b=eHma7LXGhk/IYSYC5i8X0WYAiUwf2aWhYJiZTdzBB5omyUNGfQgwv67lkF/dJsT0ni
         7ACVmAdmFlORj4+u+cNlmGSfz2DaOrcB8gCLOf1QLQt9RST254hf854w8JwSrBanH1pV
         T6gZV7mVvtlgBQERNAEzV6xEdJTFOMqxqJsVNOqrUmrTFhZwgXisSpqAj+ZLdCnFa4OO
         krfHWpCdLoQc0Mah0xNhqp3sSws/SQqeJubyj9rVS6oJPBDPvqdulvhC476kdG7GExnf
         JaKWELRsUo+3b2bSuW9bR6jO/WTZPAi4D73gEp1dtMlEyrlRqqqc3dhDf3nqjE6VRVhS
         xErg==
X-Gm-Message-State: AGi0PuZHkUWtqAz/kqXsCWd636c0n84euNAUVnmtXYbP7V7GFmmTPTqY
        +j5egkJUI8eqwV06ZBAM0MaEDwW2BXqhDiel8609IB5CZTqznzpB1sLHyFZzeWKN94zL0mMn7hl
        ol9/mMCvpy0XK
X-Received: by 2002:a05:620a:13a7:: with SMTP id m7mr14264305qki.498.1589213708412;
        Mon, 11 May 2020 09:15:08 -0700 (PDT)
X-Google-Smtp-Source: APiQypLFlqG5vF/e7y0pD5EcKe9ThQIhRa2tEFR+EpAWfKOuQOPTdjVG8EmWZz7lFamA9ZguN16SpQ==
X-Received: by 2002:a05:620a:13a7:: with SMTP id m7mr14264282qki.498.1589213708136;
        Mon, 11 May 2020 09:15:08 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id c24sm6645942qtd.26.2020.05.11.09.15.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 09:15:06 -0700 (PDT)
Date:   Mon, 11 May 2020 12:15:05 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 8/9] KVM: x86, SVM: isolate vcpu->arch.dr6 from
 vmcb->save.dr6
Message-ID: <20200511161505.GI228260@xz-x1>
References: <20200507115011.494562-1-pbonzini@redhat.com>
 <20200507115011.494562-9-pbonzini@redhat.com>
 <20200507192808.GK228260@xz-x1>
 <dd8eb45b-4556-6aaa-0061-11b9124020b1@redhat.com>
 <20200508153210.GZ228260@xz-x1>
 <a0dd65bc-bfea-75b8-60d7-5060b9ee6c51@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a0dd65bc-bfea-75b8-60d7-5060b9ee6c51@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 09, 2020 at 03:28:44PM +0200, Paolo Bonzini wrote:
> On 08/05/20 17:32, Peter Xu wrote:
> > On Fri, May 08, 2020 at 12:33:57AM +0200, Paolo Bonzini wrote:
> >> On 07/05/20 21:28, Peter Xu wrote:
> >>>> -	svm->vcpu.arch.dr6 = dr6;
> >>>> +	WARN_ON(svm->vcpu.arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT);
> >>>> +	svm->vcpu.arch.dr6 &= ~(DR_TRAP_BITS | DR6_RTM);
> >>>> +	svm->vcpu.arch.dr6 |= dr6 & ~DR6_FIXED_1;
> >>> I failed to figure out what the above calculation is going to do... 
> >>
> >> The calculation is merging the cause of the #DB with the guest DR6.
> >> It's basically the same effect as kvm_deliver_exception_payload.
> > 
> > Shall we introduce a helper for both kvm_deliver_exception_payload and here
> > (e.g. kvm_merge_dr6)?  Also, wondering whether this could be a bit easier to
> > follow by defining:
> 
> It would make sense indeed but I plan to get rid of this in 5.9 (so in
> about a month), as explained in the comment.

OK. I thought it would be easy to change and verify when with the selftests,
however it's definitely ok to work upon it too.  Thanks,

-- 
Peter Xu

