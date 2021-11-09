Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5529E44B90F
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 23:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbhKIW5V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Nov 2021 17:57:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241394AbhKIW5R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Nov 2021 17:57:17 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB2BC06EDC8
        for <kvm@vger.kernel.org>; Tue,  9 Nov 2021 14:33:47 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id p18so1167870plf.13
        for <kvm@vger.kernel.org>; Tue, 09 Nov 2021 14:33:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PpXPTnC9PJk2qXeecO16ToJugSAUS42+BOt5z52f2mA=;
        b=FrDeVutfgIc3x7y+VGVhBzAiD3EfNDQILAhvjFrddCQgdzUc3z1cg9edttkzipBfax
         F581asD+UqEKrDEHrXVxsEFIDaGoHql9rimrwIQNYVF9dCkaR2Ol66CCJKrvaM3iG2Da
         aK9XMmAbA5cTeaJYPzGEVNIBYD7pSMF7x+XQJffYbZXTkSvhKYgtCiy6u4wIkaChwnIj
         CIKTC1wvTdR7VB5K7hfi49+5nTzrnLoRnJKBHiug64WXZT1bu24sMmgr8VkKSu4MTxPd
         o7IrKw8rVcQlUIPL2+x/tpkqrQCaVsxMmoStw5D2FR/ucK33vVMgZ5Eh+UtgpnzYbSuU
         F6nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PpXPTnC9PJk2qXeecO16ToJugSAUS42+BOt5z52f2mA=;
        b=TlAdQZlSPytsHikInzpdQAubA0dOGUfvKirfxsFClw70zXw6BjgyqJ9zZ7aA6FDK3J
         NW2iNMcuy+0WegRvbLQwOUZiJAet495XwiBrHkZmNY854HFwln/MLxBj+mPGyddOSf82
         wwcHSf4Fsxv7swC+O4l7qAKKH77taN58Jo0jqoF1R8ES8RcnkNl9I5JrZY9umS591WBt
         1hmwKv5kcGIYww374W0rV2g5Xa8MSterBIw/Z+HhBfYYK+zNwGbxCTGKKbEnVhYmdzUa
         ueFsO0p16vfxDYwRxkgXC42IxaVpA+qobbY6YJEymB0PObKk710CdhmzFEnqcpyFUBl5
         pTHg==
X-Gm-Message-State: AOAM533norvMHhsWccZPe6OO9EokMVPo3FN+RKAJZklhD0wcyGRlOKlp
        YnJU+Cf5XTRNBcZDqW2Tj781gA==
X-Google-Smtp-Source: ABdhPJxzRmL+yOk7wrVL9rRF8riPXFZWUAL1KTmfbfRGwlKH7Ug1NgxI1tm5CH26uxzYgU2uXFm0cQ==
X-Received: by 2002:a17:90b:1b06:: with SMTP id nu6mr11195711pjb.155.1636497227195;
        Tue, 09 Nov 2021 14:33:47 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id ml24sm3454718pjb.16.2021.11.09.14.33.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 14:33:46 -0800 (PST)
Date:   Tue, 9 Nov 2021 22:33:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v1 3/5] KVM: x86: nVMX: VMCS12 field's read/write
 respects field existence bitmap
Message-ID: <YYr3R8ehb/1tsCDj@google.com>
References: <CALMp9eQvRYpZg+G7vMcaCq0HYPDfZVpPtDRO9bRa0w2fyyU9Og@mail.gmail.com>
 <YVy6gj2+XsghsP3j@google.com>
 <CALMp9eT+uAvPv7LhJKrJGDN31-aVy6DYBrP+PUDiTk0zWuCX4g@mail.gmail.com>
 <YVzeJ59/yCpqgTX2@google.com>
 <20211008082302.txckaasmsystigeu@linux.intel.com>
 <85da4484902e5a4b1be645669c95dba7934d98b5.camel@linux.intel.com>
 <CALMp9eTSkK2+-W8AVRdYv3MEsMKj-Xc2-v7DsavJRh5FLsVuCQ@mail.gmail.com>
 <3360abf3841a5d3234ac5983dd2df62b24e5fc47.camel@linux.intel.com>
 <CALMp9eQruRB3WEuwe2PEyEmbYUcJC_vR86Dd_wPTuqjb212h+w@mail.gmail.com>
 <32f506647ff99f58441ed1281c1db84599d48c8c.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32f506647ff99f58441ed1281c1db84599d48c8c.camel@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 03, 2021, Robert Hoo wrote:
> On Fri, 2021-10-29 at 12:53 -0700, Jim Mattson wrote:
> > On Fri, Oct 8, 2021 at 5:05 PM Robert Hoo <robert.hu@linux.intel.com>
> > wrote:
> > > 
> > > On Fri, 2021-10-08 at 16:49 -0700, Jim Mattson wrote:
> > > > We have some internal patches for virtualizing VMCS shadowing
> > > > which
> > > > may break if there is a guest VMCS field with index greater than
> > > > VMX_VMCS_ENUM.MAX_INDEX. I plan to upstream them soon.
> > > 
> > > OK, thanks for letting us know.:-)
> > 
> > After careful consideration, we're actually going to drop these
> > patches rather than sending them upstream.
> 
> OK.
> 
> Hi, Paolo, Sean and Jim,
> 
> Do you think our this series patch are still needed or can be dropped
> as well?

IMO we should drop this series and take our own erratum.
