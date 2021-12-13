Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA174733F7
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 19:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241461AbhLMS2Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 13:28:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbhLMS2X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 13:28:23 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4634AC061574;
        Mon, 13 Dec 2021 10:28:23 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id o20so55511749eds.10;
        Mon, 13 Dec 2021 10:28:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XpaXJ4WEaD6zR3bCvxQal3Iu5boNNpcIvA4GyYqNIQA=;
        b=RBh1VxvlVJNteBG38FTKIsyI6B2SYA0Z/IuxIthA72Or2sMS9h7A0vTZMnoYsDY93D
         Ra9Longtdbr8s/q6IHICmURMM10zkQZORYz7SmWkl/6wv7rd5v0iegHZbKtrQ6Q471Ni
         i9pm9UIaRDYQ2BPmaEHadnXlZbN2n+gZ2q4qJglM1dT0UMAvujqixNuFIZek3xWB/K2I
         AkLg6guT/QqKVcnczADHeyu8jC8xX/QLadHCxPPY1may5Uf4eO65OnPfn1lOlNZB/8hz
         TyQqFjCw4XOONgaNajI9GIlxHlxAc+qWn95GDdMVynWV4tBdXBwikqoMTQIhZBs71Zes
         IVXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XpaXJ4WEaD6zR3bCvxQal3Iu5boNNpcIvA4GyYqNIQA=;
        b=3bBrSzYCvS3eMtPbzWP9wWMpqd9JdzGE7zU6q5681GwYS2jny0EhOWys3bWMhCne5e
         Si0sWOB2TYT1zo7mfrFggtB0R2FXiXgRB0KY7KfjvERxfT1gsgjlom6fFj/lr2MRunln
         Uhp0yBPkGh4P6pm7wYpfp5fKxu2DxhToetm20T1E0RkF6CaCHoZtnGnJF7knepDuuBk4
         ZyENU1d3ChHqR8v3Yho08Nv+8PauBLYIcUWRuCfbWosj7hio5PV+1HW8u9F/6KCsnXU2
         3wjyXIBVAiuRXbUsInjwMG34dcOU6G/bjrAvuaATe1p7RxM1GbiROxCjc+USl1e2JHQ9
         ENCg==
X-Gm-Message-State: AOAM532nPRSVeKjh28c59n8FNQGR4Q9n6L40+2D8G2hAXm5wY91k7vDn
        UaHi09Zh/MaYDcOdecRGuDI=
X-Google-Smtp-Source: ABdhPJyr7A1WlSTrGLrtY4qJglxiWW/0hsQvjlu3YZnwkgX95ctxqH59Ni3q0SYj7QHHWW5QKubayQ==
X-Received: by 2002:a17:907:6290:: with SMTP id nd16mr98647ejc.578.1639420101799;
        Mon, 13 Dec 2021 10:28:21 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id eg8sm6633928edb.75.2021.12.13.10.28.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 10:28:21 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <b020080a-ce54-d493-12dd-fb7a428169f4@redhat.com>
Date:   Mon, 13 Dec 2021 19:28:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 0/2] KVM: x86: Fix dangling page reference in TDP MMU
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Ignat Korchagin <ignat@cloudflare.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        bgardon@google.com, dmatlack@google.com, stevensd@chromium.org,
        kernel-team <kernel-team@cloudflare.com>
References: <20211213112514.78552-1-pbonzini@redhat.com>
 <CALrw=nEM6LEAD8LA1Bd15=8BK=TFwwwAMKy_DWRrDkD=r+1Tqg@mail.gmail.com>
 <Ybd5JJ/IZvcW/b2Y@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Ybd5JJ/IZvcW/b2Y@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/13/21 17:47, Sean Christopherson wrote:
> On Mon, Dec 13, 2021, Ignat Korchagin wrote:
>> Unfortunately, this patchset does not fix the original issue reported in [1].
> Can you provide your kernel config?  And any other version/config info that might
> be relevant, e.g. anything in gvisor or runsc?

Also, I couldn't even get gvisor to run; it cannot start gofer and fails
with

starting container: starting root container: urpc method "containerManager.StartRoot" failed: EOF

(I only tried CentOS 9 and Fedora, both with cgroupv1 enabled).

Paolo
