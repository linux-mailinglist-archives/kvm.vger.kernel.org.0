Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E451A436BBE
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 22:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbhJUUG7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 16:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231952AbhJUUG7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 16:06:59 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B35C061764
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 13:04:43 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id m21so1257757pgu.13
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 13:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BJdYaoVntWzrTJu7xhe7fmZqFzNwWeTLt9gWbNrG0tI=;
        b=DyZK5UjsLM2sesHrMIFKiCLvbwjjm6pRQYaHN6kh2bjdpBd+o7evkX3d9O/HB2gCVy
         9HS0r8ymYKhTg12KN8I4CrhlEfdKv4Xk3ALOHQ4mXeLFdHKKF+mUYFzEPXic2/yH4KVi
         GzZ0x5/cF9q2KuyWxEkNaSc070B2tZ9WFJBm2oolGEsbcrdTtb/fnQYFp+UQqugJPxij
         Ov2JgMaSOXUiH81fVFEKMW7mQWqRLHkh6qm7U7+SkK1mPCgCd04d+lxPNvXVHHt2g2Zl
         Uq8MNQ8zSwMpdqGt7Nn/BOQsbipMtnMmbuRW9zbbDQGiS12bvzZfiCd+zwc53SUEULGQ
         aGtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BJdYaoVntWzrTJu7xhe7fmZqFzNwWeTLt9gWbNrG0tI=;
        b=HlHp5FWI+wfDTvmC5ocn73klYuMJhagrihXNE9R84oSNTIPwrWbKSN01Mf0DYxgG1y
         9hy4LiRUh+SFeCwc4/ZkTA1rvIWVzWYYPgkpowouGazR2ROCd6JOkXyUQciSmRV7G9Mr
         C42VHRdV+jveqh8N/KVVhIJMCfCaPDtgQcKSHE2UEZrhZLTfBxeFHK9eYQEt3jThRuj7
         j6Uz8YjZi0pxQzy0NwzVlkYFG3aFuNxP0anLIW2/xqCrLPBChLKU6xiR+6BrkfuFbs6b
         XGhqj9Am2Bo+9F9P7nxlDgUEtb4FIBpTWdxqNQ7wLLkGEdK9yAR7J37jKt55VHBWebJw
         m6Qg==
X-Gm-Message-State: AOAM533MoLKC30NK3Moj62MudOXvSpBl8xIcLRKjrnt4z0PkFzbEd3D1
        OSKSJ1qobhKXrt+WoSCgzDGe4Q==
X-Google-Smtp-Source: ABdhPJyB+o2LF+Q8z+muxQ99/9OkhcI4FKylH+wkYoTPlnXf+riWGqXzgHGVhrTsmBfPFL1UGvcRWg==
X-Received: by 2002:a05:6a00:24c1:b0:457:a10e:a0e with SMTP id d1-20020a056a0024c100b00457a10e0a0emr7511096pfv.63.1634846682353;
        Thu, 21 Oct 2021 13:04:42 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f21sm7567450pfc.203.2021.10.21.13.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 13:04:41 -0700 (PDT)
Date:   Thu, 21 Oct 2021 20:04:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        fwilhelm@google.com, oupton@google.com
Subject: Re: [PATCH 0/8] KVM: SEV-ES: fixes for string I/O emulation
Message-ID: <YXHH1shFlGWyZqlw@google.com>
References: <20211013165616.19846-1-pbonzini@redhat.com>
 <435767c0-958d-f90f-d11a-cff42ab1205c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <435767c0-958d-f90f-d11a-cff42ab1205c@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 21, 2021, Paolo Bonzini wrote:
> On 13/10/21 18:56, Paolo Bonzini wrote:
> > This series, namely patches 1 and 8, fix two bugs in string I/O
> > emulation for SEV-ES:
> > 
> > - first, the length is completely off for "rep ins" and "rep outs"
> >    operation of size > 1.  After setup_vmgexit_scratch, svm->ghcb_sa_len
> >    is in bytes, but kvm_sev_es_string_io expects the number of PIO
> >    operations.
> > 
> > - second, the size of the GHCB buffer can exceed the size of
> >    vcpu->arch.pio_data.  If that happens, we need to go over the GHCB
> >    buffer in multiple passes.
> > 
> > The second bug was reported by Felix Wilhelm.  The first was found by
> > me by code inspection; on one hand it seems *too* egregious so I'll be
> > gladly proven wrong on this, on the other hand... I know I'm bad at code
> > review, but not _that_ bad.

String I/O was completely busted on the Linux guest side as well, I wouldn't be
the least bit surprised if KVM were completely broken as well (reviewing now...).
