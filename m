Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E54BB2D74DB
	for <lists+kvm@lfdr.de>; Fri, 11 Dec 2020 12:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394949AbgLKLoE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Dec 2020 06:44:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47462 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391254AbgLKLnf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Dec 2020 06:43:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607686928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ry4QLCFBuVcgRrGECJpsR3PjwcufaE79G5/vr18zuM0=;
        b=iXlSGoI5cJLyqwZbnsO1dlJqWi3vgdRGlVaq88LvU+NHZ65jXBA5PJB1HmTs1YNKR9ArcP
        /llOGy5sTtVX4mOCUq47cUHHzV5/dh/vVliha91f53fL72CiIWr6FPtfX+uivvH1cyGmRm
        4c8gmxVzqRjVHxokq93R3c4AM2QyXCo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-qCUuYJQXPoeL9_bPfNnoiA-1; Fri, 11 Dec 2020 06:42:06 -0500
X-MC-Unique: qCUuYJQXPoeL9_bPfNnoiA-1
Received: by mail-wm1-f70.google.com with SMTP id 4so1601761wmj.2
        for <kvm@vger.kernel.org>; Fri, 11 Dec 2020 03:42:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ry4QLCFBuVcgRrGECJpsR3PjwcufaE79G5/vr18zuM0=;
        b=K/FWGPAn92BcC2H06ue8HN4OdwzSsSQ3FlHCTtsqrcm2cCIU37xc0Tu5Qyh1RsUy62
         qOYg5vg/Qq3Nxq+AGDrjpV72rLrFGz3OCkwhjXbre0wccj0DicbakwEarKKZf8cR9sNe
         sks7HywcsPR2XmjiIDsKanxhGXYW1X+SX3OuHfpOOvJKcK/hg8bh7WLzv4vmO14VzuB3
         WLLgfDV5IlZsauIla+sd/lPA0K2/GjdbA0v1eaq25LIds9Be6vzieaBSQxBafGilcC20
         OKdum27PEcDI1TQMhYYBYe0Kfop5jy8AYh9PbUyN6ucvVY12lEkDx/XVGEArvBmpZC2V
         j8pQ==
X-Gm-Message-State: AOAM532NGjxr2J1sryZ9/WI8D/2aTjrZJPnZRw5GKEkTuM/O2UhXHmpT
        Yne8aRloS5uUeDjMFkNgslTsdI3gb7CukHZaktJaHfxaFxX/UluyXF9E75Z0YLbVPOtKLHIJBT1
        D9aQyDa6rE1FM
X-Received: by 2002:adf:8185:: with SMTP id 5mr13009133wra.44.1607686925142;
        Fri, 11 Dec 2020 03:42:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyXgc91RMaWJBoQmaitT2etxSTZvic/O2Map1BC8Kl98FhLjU4l6ovbObXtEGhr9cTTmfJCSA==
X-Received: by 2002:adf:8185:: with SMTP id 5mr13009097wra.44.1607686924922;
        Fri, 11 Dec 2020 03:42:04 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id c129sm14174329wma.31.2020.12.11.03.42.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Dec 2020 03:42:03 -0800 (PST)
Subject: Re: [PATCH] KVM: SVM: use vmsave/vmload for saving/restoring
 additional host state
To:     Sean Christopherson <seanjc@google.com>,
        Andy Lutomirski <luto@kernel.org>
Cc:     Michael Roth <michael.roth@amd.com>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20201210174814.1122585-1-michael.roth@amd.com>
 <CALCETrXo+2LjUt_ObxV+6u6719gTVaMR4-KCrgsjQVRe=xPo+g@mail.gmail.com>
 <160763562772.1125101.13951354991725886671@vm0>
 <CALCETrV2-WwV+uz99r2RCJx6OADzwxaLxPUVW22wjHoAAN5cSQ@mail.gmail.com>
 <160764771044.1223913.9946447556531152629@vm0>
 <CALCETrVuCZ5itAN3Ns3D04qR1Z_eJiA9=UvyM95zLE076X=JEA@mail.gmail.com>
 <X9LLFMN5CNPIikSp@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5083c2dd-5aed-f7a9-4267-04cfca92032b@redhat.com>
Date:   Fri, 11 Dec 2020 12:42:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <X9LLFMN5CNPIikSp@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/12/20 02:27, Sean Christopherson wrote:
> Michael, please reply to all so that everyone can read along and so that the
> conversation gets recorded in the various mailing list archives.
> 
> If you are replying all, then I think something funky is going on with AMD's
> mail servers, as I'm not getting your responses (I double checked SPAM), nor are
> they showing up on lore.

I think somebody else reported similar issues with AMD's mail servers.

Paolo

