Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1C9984C3
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 21:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730217AbfHUTsp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 15:48:45 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:38015 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730014AbfHUTso (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Aug 2019 15:48:44 -0400
Received: by mail-io1-f66.google.com with SMTP id p12so7090212iog.5
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2019 12:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W/FKUsI28DeU0RstFXTPREgngr4rJSTzC7of+9eSaSg=;
        b=q9iDAGEX9A9tYk1Yt2FvedzkSFMe6vss8hgfcenSCqQ6Sq/xtfbroD62XrV9bz39Vp
         CcANgaPV5Z06k7K7j6rABXBxExeAmH1IeZ1vLnB9AfmKe634584Ovfk8UBtLOLL+0u14
         07XvYxyW4Z16F8N5HGCK0hs/KTDUNqk5/QH9AfAnETRIEzg3P6xPeCAVHNbq3UcaznZD
         iTwH3ISsqo397BbsAbq9ZAHNbUohmVc01rbxJdYhE8rsqCBq54VRQHAaWd5+gTC0y6o7
         Wuq4kAw0YavSoZ2iQ5s8x1lV8J6z0bYravmBVRmujYtpgYrrIELKqXFaq3wW6QUKF83X
         6JIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W/FKUsI28DeU0RstFXTPREgngr4rJSTzC7of+9eSaSg=;
        b=nbuHo7A4qErkyszF1CSy0F7JOEfUaVWLoyhAwFfFwpqS5T1UjAp/DYHZWlbQnPC3Uq
         FXO8s673X9gO6PgXHC35Z80Vafs1/ryOLqeSf6HmxYV3weHNDK9zil/Qkonf8hRdC9Ma
         cfU8w5W/hXHBZjQsckCk+Nx7wHReuFxX7+ZlQkML00UBrpZOEKoyGlVnvUBxZcTUkb0L
         w/MLa8Fko9FrdOg079RemAXze12RULv7PGK9lcH8Hzl7typseeCr3/9gEmuVCeNXtJGG
         Q5aJmC23h5pIM7Fhl6cfQAFPcBEDOzEfo5yyero/1T+7j3/2nxfQZdkpQZ6jljwTem4/
         g/6w==
X-Gm-Message-State: APjAAAVoPV8p9YThISCDMxZF9BHj5Cvs3/Y3cdpO7AYEDaPxa6CydpSf
        IwBBf/wrxFFsOu0sUB0VPeAUISPtxNneXvIzEMUhFdCsoDrOBQ==
X-Google-Smtp-Source: APXvYqyza1onGK2ZL65dtOsaHuiPoV4r7myeGa1KIgljwyyjmR/zF9+g47qeVsrR1uxk1j7Drv/nVRXTvqNv7dE/IUY=
X-Received: by 2002:a02:a809:: with SMTP id f9mr11872478jaj.111.1566416923268;
 Wed, 21 Aug 2019 12:48:43 -0700 (PDT)
MIME-Version: 1.0
References: <1566376002-17121-1-git-send-email-pbonzini@redhat.com> <1566376002-17121-4-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1566376002-17121-4-git-send-email-pbonzini@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 21 Aug 2019 12:48:32 -0700
Message-ID: <CALMp9eQX5m-g=D-J=h86rTrkQCB_BdJi56jGuANrQqv_-gw_Nw@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: x86: use Intel speculation bugs and features as
 derived in generic x86 code
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, jmattson@redhat.com,
        Eduardo Habkost <ehabkost@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 21, 2019 at 1:27 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Similar to AMD bits, set the Intel bits from the vendor-independent
> feature and bug flags, because KVM_GET_SUPPORTED_CPUID does not care
> about the vendor and they should be set on AMD processors as well.
>
> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
