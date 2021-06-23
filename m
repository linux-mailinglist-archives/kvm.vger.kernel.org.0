Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003E73B1E90
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 18:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbhFWQYL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 12:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbhFWQYL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 12:24:11 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC89C061756
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 09:21:53 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d1so799224plg.6
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 09:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5ii3VcP6yGwaAHrYr2ovsq7dBZBjX3jJHACpeShViPA=;
        b=Dlvu2xzM8dvWAc4U4/8TT762Zpj56AIzsK0NYI9mRdYCfh55Vfg4tRKBpYdu7TFobJ
         CFIOsn8YGIsF+zPP9HbuS+IDufTO2SXbJhWYAL5fdo3M17FumZy8KXAz3TPraxlaAcbr
         jt8qAcMBy9dvRiDp61IHT3QvZYMCrr7Yf7plDNs7kJIkRYO8OupGAlX+fobPB5AdNpw2
         2geqhPltSYJPV71YZe1AwuJ/HJt0vf7xxjWC4rLUNUXO643c4aswcy+cJgmm7lmjEcbg
         2BSG7jU/TG/G1l/W32hN27YvLhBpaecf3cUJSCtnfwraAS9WZEHS7UzPok5PNbVHj0sl
         BOUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5ii3VcP6yGwaAHrYr2ovsq7dBZBjX3jJHACpeShViPA=;
        b=Io59k7dPwKexnnldgOgzPPmcbWeMIgQL1HBKbWjNVTpZhWD+iRuyAvcNRBTlWCrMqz
         bf/OBOBrmt7MnzfIkwlrjvTtz2hEe2LN6WFFkL+4yyQ/OB+w4AwtaeOxYQeozPC+uEQc
         PvtV9hBk4u+u84X2PP0SdSuUCX/lsttE0xpx8mdijO8TO+esoyrbKz/kLspt+JhmzzKi
         zRZsxy2OK45wFDT5SOJ/eFFKO1nsIDJZ2iAma+qOnsvkBQwcoRJ/K/vNFBE+D9PHfbnS
         uuPLdaLS7qmCIRPwoFUXQ2W2e3dW35x9EPT/Keguzi/b71A20zjxagmuPod23X0Pd5cw
         uoMw==
X-Gm-Message-State: AOAM533ovWPX0m26IPklT31fwpDx/JHtPXLw8YjtL8D41SjVtjCD7FEE
        c1PWzEJETo1ozio0T7LLazoA3Q==
X-Google-Smtp-Source: ABdhPJyXzBIJ4uuVHOJ30Az+pMillzqNM3ekwhaPQbi6PBAbIcP27gEaHHBiJF2yLHpN5F+4CzIiGg==
X-Received: by 2002:a17:90a:8a95:: with SMTP id x21mr556761pjn.154.1624465313070;
        Wed, 23 Jun 2021 09:21:53 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b18sm5960931pjq.2.2021.06.23.09.21.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 09:21:52 -0700 (PDT)
Date:   Wed, 23 Jun 2021 16:21:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Cathy Avery <cavery@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH RFC] KVM: nSVM: Fix L1 state corruption upon return from
 SMM
Message-ID: <YNNfnLsc+3qMsdlN@google.com>
References: <20210623074427.152266-1-vkuznets@redhat.com>
 <a3918bfa-7b4f-c31a-448a-aa22a44d4dfd@redhat.com>
 <53a9f893cb895f4b52e16c374cbe988607925cdf.camel@redhat.com>
 <ac98150acd77f4c09167bc1bb1c552db68925cf2.camel@redhat.com>
 <87pmwc4sh4.fsf@vitty.brq.redhat.com>
 <5fc502b70a89e18034716166abc65caec192c19b.camel@redhat.com>
 <YNNc9lKIzM6wlDNf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNNc9lKIzM6wlDNf@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 23, 2021, Sean Christopherson wrote:
> And I believe this hackery is necessary only because nested_svm_vmexit() isn't
> following the architcture in the first place.  I.e. using vmcb01 to restore
> host state is flat out wrong.

Ah, that's not true, using vmcb01 is allowed by "may store some or all host state
in hidden on-chip memory".

From a performance perspective, I do like the SMI/RSM shenanigans.  I'm not
totally opposed to the trickery since I think it will break a guest if and only
if the L1 guest is also violating the APM.  And we're not fudging the spec thaat
much :-)
