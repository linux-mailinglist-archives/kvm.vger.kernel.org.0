Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF8662E22A
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 17:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240497AbiKQQkZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 11:40:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240574AbiKQQkF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 11:40:05 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F1DA6277
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 08:39:46 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id y13so2287914pfp.7
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 08:39:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=H9ws/VoANOQ+fPSn5rwf5FxpcOUa4clnxCqjB4jQHRk=;
        b=rkmo6VLfA7ZdFlFYhci1eHa8YuAnNI7OCzahqFlLSSgWBhldvSblGwM0x4Ph5VSzWL
         wxQZv55hGZPoy52j6/mWI9ors9jeYz6ewrstfFNZX0SlEY2j55aRTOjVNifOqruC+GU9
         SC+xz1Pu/ZD5tUpuOajkCW2ZkXDx0T33SZcgsNYzU5vBzFQigzdFtrpnyctEO/k9Lcc/
         Qx998qMUFq2FMQ1KjrSB+UadktrgmNujLZYVp2ldw7uDQF7X0n9W/v/jReBYtiLAJcN7
         bSR7Jo6x9NDFwoO+6I8JKUVnU8SBKeyZ2zYV0jpzoosBXIya7r1tZP59YoL6uua/LeqX
         1BeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H9ws/VoANOQ+fPSn5rwf5FxpcOUa4clnxCqjB4jQHRk=;
        b=a20jxuN3/3aEE3/s3dxmj1dhsmuT+Wrp8w+ualTLKLM1Ghrh7co0h3H+yU4/eHIukS
         ZmUcRpD17Yl8hqg5QtQhpReM/JCaAhmnwoNOfhmAc5Zh96IrnHjXI42+TkF8ZMHxGHo5
         S8nc5tihC8NTI4nIIa0bNX7XKJ1Sbf8V0l0TB5z6nh5Lw6iHgy2uSERP2OrsRuIs2fOw
         YgwqD7/hKivTfk5MuE+dU6At+XPX6TfDx1sPtilkjTFCltu1VtZp6b1TPuMUSs9oVXQT
         42ozt6cSKBsKxq9LVp7NvsZqt+/L6FjU37UaQe4Wd7as926H7G1GtyB6YARgUm8fgTKj
         jhaA==
X-Gm-Message-State: ANoB5pnW4KMNZmkEDhETseRdD9HtBFlaqkgXHt8Fz6JFrszT6mC2eLPa
        MbkH3dBIQN7OkuWh7kocO3QELUelcVDA/Q==
X-Google-Smtp-Source: AA0mqf6fzW9qRwwqPD9MopcDpVcg8k/LRSPgQMy3+TDj5emGCtMVyTxrDINepW4yBPCQrROWlOdO9A==
X-Received: by 2002:a05:6a00:21c1:b0:562:86a3:12fc with SMTP id t1-20020a056a0021c100b0056286a312fcmr3853688pfj.8.1668703185541;
        Thu, 17 Nov 2022 08:39:45 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id p10-20020a17090a4f0a00b001fe39bda429sm1094934pjh.38.2022.11.17.08.39.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 08:39:45 -0800 (PST)
Date:   Thu, 17 Nov 2022 16:39:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Matlack <dmatlack@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2] KVM: x86/mmu: Do not recover dirty-tracked NX Huge
 Pages
Message-ID: <Y3ZjzZdI6Ej6XwW4@google.com>
References: <20221103204421.1146958-1-dmatlack@google.com>
 <Y2l247/1GzVm4mJH@google.com>
 <d636e626-ae33-0119-545d-a0b60cbe0ff7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d636e626-ae33-0119-545d-a0b60cbe0ff7@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 17, 2022, Paolo Bonzini wrote:
> On 11/7/22 22:21, Sean Christopherson wrote:
> > 
> > Hmm, and the memslot heuristic doesn't address the recovery worker holding mmu_lock
> > for write.  On a non-preemptible kernel, rwlock_needbreak() is always false, e.g.
> > the worker won't yield to vCPUs that are trying to handle non-fast page faults.
> > The worker should eventually reach steady state by unaccounting everything, but
> > that might take a while.
> 
> I'm not sure what you mean here?  The recovery worker will still decrease
> to_zap by 1 on every unaccounted NX hugepage, and go to sleep after it
> reaches 0.

Right, what I'm saying is that this approach is still sub-optimal because it does
all that work will holding mmu_lock for write.  

> Also, David's test used a 10-second halving time for the recovery thread.
> With the 1 hour time the effect would Perhaps the 1 hour time used by
> default by KVM is overly conservative, but 1% over 10 seconds is certainly a
> lot larger an effect, than 1% over 1 hour.

It's not the CPU usage I'm thinking of, it's the unnecessary blockage of MMU
operations on other tasks/vCPUs.  Given that this is related to dirty logging,
odds are very good that there will be a variety of operations in flight, e.g.
KVM_GET_DIRTY_LOG.  If the recovery ratio is aggressive, and/or there are a lot
of pages to recover, the recovery thread could hold mmu_lock until a reched is
needed.
