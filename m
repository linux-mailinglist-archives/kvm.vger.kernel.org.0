Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B381C4A9CF7
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 17:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbiBDQan (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 11:30:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376604AbiBDQaj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 11:30:39 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 135D5C061714
        for <kvm@vger.kernel.org>; Fri,  4 Feb 2022 08:30:39 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id l13so5580086plg.9
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 08:30:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zqgFTipAZj9pEj8eBBkdwsSaq6y1Vfc1/+fKsuVbzmM=;
        b=HYgwvETeLmcfLy7X2U55nLwn0M4sZFi2WNXSAQfU0hr3M4BffFj7O9OETuB7HgHK+/
         Q6PTDNg72CMcuiUfj9AJzCF038aF5QnwKpKg77aCEGU7tv9hLE/KneL/GBaqE8FNBgSi
         irrcqjTNzDysAmSsDbcUsoYMZ9Yb0Sc3fg7EqyvdWb0u0TSEzIB9keq12ugiRZgfOERM
         APpqHo4M1MrQERdXkOoG33Q1N3xZzR8dzm10iW99UvwGiFRWQCeIue0BlSMwT5N+9irH
         uoAIhOz4ttQBSXD1P5XXJ0fksAjlDi55lRPAUjF+AgvG2QauCX7XH8zIbjtoCN5Ocq8S
         dhgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zqgFTipAZj9pEj8eBBkdwsSaq6y1Vfc1/+fKsuVbzmM=;
        b=RK8VU+eWPR70Hq93Xj71B38x/JYJiehOX8hpe2hIbWNyZW7YEjRRZeUszjtdhDMItN
         irh/942h/291ys/RE352nWcHbu5hwXY2mhAO0noSwZ5qMlUYGQgB9LEPEmqlxSh+AyJr
         +uRFU3LFhNQAcpGOGjkesTGM/XAxoLT333nXdWZJ3dMmevm0eUsIjxPtOtw7NXUVxwnL
         m3Vc+OkC1QWyyRpdk6/eSVMzafQ5nXj7yW+FADt1K3KCfqOR88M2EEN60Teo2zEpcXEG
         keTLZnuZX8exSoVBXXeaalbG1f8pJ2sS+LZIQ/ZN/Ep/5dFdB7kXmFfWftNi8q1Trg1k
         lHjA==
X-Gm-Message-State: AOAM531Qi72Pyk3a6Iq4CRQu444xiuf1gsFBjvq9V5XU7zIfx5S0yny9
        o0mxBUY/VBhh1QlFClTfN5+gBw==
X-Google-Smtp-Source: ABdhPJzZU6Fiq4IoCNGxXyy201S66PFs8Evk52FTKTDRc3WcHlGCoOfLDizAwODe9HE3xCIJ+eEHWw==
X-Received: by 2002:a17:90a:f0c9:: with SMTP id fa9mr3984494pjb.131.1643992238294;
        Fri, 04 Feb 2022 08:30:38 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id nu7sm2971164pjb.30.2022.02.04.08.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 08:30:37 -0800 (PST)
Date:   Fri, 4 Feb 2022 16:30:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Orr <marcorr@google.com>
Cc:     Joerg Roedel <jroedel@suse.de>,
        Varad Gautam <varad.gautam@suse.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Zixuan Wang <zxwang42@gmail.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>, bp@suse.de
Subject: Re: [kvm-unit-tests 02/13] x86: AMD SEV-ES: Setup #VC exception
 handler for AMD SEV-ES
Message-ID: <Yf1UqmkfirgX1Nl+@google.com>
References: <20220120125122.4633-1-varad.gautam@suse.com>
 <20220120125122.4633-3-varad.gautam@suse.com>
 <CAA03e5FbSoRo9tXwJocBtZHEc7xisJ3gEFuOW0FPvchbL9X8PQ@mail.gmail.com>
 <Yf0GO8EydyQSdZvu@suse.de>
 <CAA03e5HnyqZqDOyK8cbJgq_-zMPYEcrAuKr_CF8+=3DeykfV5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA03e5HnyqZqDOyK8cbJgq_-zMPYEcrAuKr_CF8+=3DeykfV5A@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 04, 2022, Marc Orr wrote:
> On Fri, Feb 4, 2022 at 2:55 AM Joerg Roedel <jroedel@suse.de> wrote:
> >         3) The firmware #VC handler might use state which is not
> >            available anymore after ExitBootServices.
> 
> Of all the issues listed, this one seems the most serious.
> 
> >         4) If the firmware uses the kvm-unit-test GHCB after
> >            ExitBootServices, it has the get the GHCB address from the
> >            GHCB MSR, requiring an identity mapping.
> >            Moreover it requires to keep the address of the GHCB in the
> >            MSR at all times where a #VC could happen. This could be a
> >            problem when we start to add SEV-ES specific tests to the
> >            unit-tests, explcitily testing the MSR protocol.
> 
> Ack. I'd think we could require tests to save/restore the GHCB MSR.
> 
> > It is easy to violate this implicit protocol and breaking kvm-unit-tests
> > just by a new version of OVMF being used. I think that is not a very
> > robust approach and a separate #VC handler in the unit-test framework
> > makes sense even now.
> 
> Thanks for the explanation! I hope we can keep the UEFI #VC handler
> working, because like I mentioned, I think this work can be used to
> test that code inside of UEFI. But I guess time will tell.
> 
> Of all the points listed above, I think point #3 is the most
> concerning. The others seem like they can be managed.

  5) Debug.  I don't want to have to reverse engineer assembly code to understand
     why a #VC handler isn't doing what I expect, or to a debug the exchanges
     between guest and host.


On Thu, Jan 20, 2022 at 4:52 AM Varad Gautam <varad.gautam@suse.com> wrote:
> If --amdsev-efi-vc is passed during ./configure, the tests will
> continue using the UEFI #VC handler.

Why bother?  I would prefer we ditch the UEFI #VC handler entirely and not give
users the option to using anything but the built-in handler.  What do we gain
other than complexity?
