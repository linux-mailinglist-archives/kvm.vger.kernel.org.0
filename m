Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA819F13D
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 19:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730166AbfH0RKE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 13:10:04 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:37809 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726871AbfH0RKE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 13:10:04 -0400
Received: by mail-io1-f67.google.com with SMTP id q22so48030417iog.4
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2019 10:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VWy+77tTGQ3qconEzAmoj4+uuLcoy/9TvX983Ina+rM=;
        b=Zl1FErqaB3jbNeSprrVrlyXSV9r4KFM/wpcMJC6G1gl5QI6t5aoeAksIxoZk/ST/8w
         M2xQ3pxE+5XYp1mBX1jbV8kSZNyHMXB0mEta7Q9nWQFIrKOKvJYyIHJxjUd046259E/4
         96hZ1PaX2+Alx3QnrtGdBZc5c/yfKpnz/xlLvsBvzwRkJRJ+0YqkV8BwyEBYWQjzrbCp
         V/83rU8KkEdR5Gox/X7YL6LTLFeO9UE3/WBcbUB20DpX+bVL7wzz/TqYlKa9NeJxShhj
         P5F9Y+EakX8iDxGvmsJxf2o4td/H68DCjEnZblMjP/DFF+Ef0sGper6B0LcxEhvrYrI/
         f9iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VWy+77tTGQ3qconEzAmoj4+uuLcoy/9TvX983Ina+rM=;
        b=Pid5AZxH2LIWxZvIXH+6oTJ56cMzJHDZgrk9MPMVictkV4WBs4jsjuc/SQ60dIba/J
         MAGoZTyRn2kgOrIqDB4pyP3o0drCDdxZeUH6F6DaR/IoSHu2CBNE7pwgQcrCjAcnmTnS
         2EaJtiywBYm07+PPoZNG0uL0gA5o9TWtA4PlmPfieM5nY2Vo2GhyCbuPVxxGfWLc4ATB
         HW3836NGcFywfXHcilXyEv2KKDUpr226I5pogE53kKOfqirV4Z/n8rMa6pMVlbS76gUy
         0nB6Gf0hOBvr2z4BtYuboJFsie7IV2oP/xUYBmH7zrxEmtBqsvvovtHyuviCucQj9dex
         enXA==
X-Gm-Message-State: APjAAAUxt06pdCd7dETZmaG9j8GQukfXeI6LZhmyDWteiwz8UmW9JuKC
        RFCasvTYhMtMz2F8gF3vo+ga2O6Ow0cftH4EQAtaMA==
X-Google-Smtp-Source: APXvYqydZJJdDg7zCx6qi1x3O1YncYyjenMPMtVUmfPNf7dJ/ExTV6t1ON1PuV71zdFslPfPEZ6l+aBfWG4qPRt41M8=
X-Received: by 2002:a6b:4e14:: with SMTP id c20mr1664014iob.26.1566925803258;
 Tue, 27 Aug 2019 10:10:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190827160404.14098-1-vkuznets@redhat.com> <20190827160404.14098-2-vkuznets@redhat.com>
In-Reply-To: <20190827160404.14098-2-vkuznets@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 27 Aug 2019 10:09:52 -0700
Message-ID: <CALMp9eRqT1VpD25cp4yyr8oVLV8vzES_uki_Xuqs-_ghGsZy8A@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: x86: hyper-v: don't crash on KVM_GET_SUPPORTED_HV_CPUID
 when kvm_intel.nested is disabled
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Roman Kagan <rkagan@virtuozzo.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 27, 2019 at 9:04 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> If kvm_intel is loaded with nested=0 parameter an attempt to perform
> KVM_GET_SUPPORTED_HV_CPUID results in OOPS as nested_get_evmcs_version hook
> in kvm_x86_ops is NULL (we assign it in nested_vmx_hardware_setup() and
> this only happens in case nested is enabled).
>
> Check that kvm_x86_ops->nested_get_evmcs_version is not NULL before
> calling it. With this, we can remove the stub from svm as it is no
> longer needed.
>
> Fixes: e2e871ab2f02 ("x86/kvm/hyper-v: Introduce nested_get_evmcs_version() helper")
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
