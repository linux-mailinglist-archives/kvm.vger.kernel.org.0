Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4243CC1B6
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2019 19:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388187AbfJDRZx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 13:25:53 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:40762 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730084AbfJDRZx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Oct 2019 13:25:53 -0400
Received: by mail-io1-f66.google.com with SMTP id h144so15169296iof.7
        for <kvm@vger.kernel.org>; Fri, 04 Oct 2019 10:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dln16A/W/aPbVdMkSQRzgwCwqw5DgFXnqTMZ/X92lyY=;
        b=TyNVCzKV0HTmPH2eFsbRtlwfpfFI5+Px6YsQ2MJIblNuMSp86y7OqSPzbJqIwBeez5
         msf2tBIAJhbZNVvZCCs7w/OJtagUgilEFr9TV/xCt1mi+HucRH8kOy7KPAH76xSX6lOk
         J5T8hfVjZaiDPZg03EUIXgQKwyTH9saUbjZblEh9i3b/pTKs0sXA9JWOkqVvrK/fgIKS
         Mx9EA9WEa/gfiGZ9tqeHfbWVpmm/wJBe8JFjQJMoZ43Wb++sEZJxSZ4tArebe4RX+Qly
         fnqH3/OZsGkCpRDxSad7WTXwnuAeSt0AjbcrmeQ2fP7OWjPeJoZglqKzbUVR0LY/JMkV
         N0yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dln16A/W/aPbVdMkSQRzgwCwqw5DgFXnqTMZ/X92lyY=;
        b=Pd3a6DcpZkob+PPZFFiulPUYv9icQlqBi1R99OirToSOV7vI1HLkqSB4tEb2q8CfRf
         fFFTIDHHEQ/Ll0MpWpSrxvlB3D0/QnrBWoEuKnrqS6G9qfZdeQkTHY9AsIVlZdTJ2cGw
         0l80fgIpFVMXpeLshhvUH7LiMBj4Ea0oW7lqRTl0VCFwyCWElSdd9rZeE5flS89Qeb+m
         U3NjC9ry2YP59321XimUQ/VyZrRSFzPNuhTyrC04V4XGDU23h9rM5VCYdSEMXBPF8JY7
         BcOgi1JGU1yWa1YBO1aRraIf5zwRMIvxEgmTFKHaSc2FbzvX5yjynj/245cIhti1HvXS
         VE5w==
X-Gm-Message-State: APjAAAXAN9h1TgaWV8Ftkyh090RR9E3U8U3lRwKTL2acPC4/RLR1THP+
        EOfDQIhNorrrEcONUYg18phdASTW6TezwNQLvNf0uQ==
X-Google-Smtp-Source: APXvYqwBnWlEPivBziVEbehucJnRyH952drSoCz/Z7vCz5BctFhJBKo9pF3Q9L8rgR0cG9sO/tcX/YyMkw4eRqpp5tI=
X-Received: by 2002:a92:8e4f:: with SMTP id k15mr18130577ilh.108.1570209951826;
 Fri, 04 Oct 2019 10:25:51 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1570137447.git.thomas.lendacky@amd.com> <0fc0372d446cb559c2a5b9389c5844df7582dc50.1570137447.git.thomas.lendacky@amd.com>
In-Reply-To: <0fc0372d446cb559c2a5b9389c5844df7582dc50.1570137447.git.thomas.lendacky@amd.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 4 Oct 2019 10:25:40 -0700
Message-ID: <CALMp9eRe8=mJM7rTrn57sWtWVWQOj0Xhwwu=4jpYfh_PDWfAaw@mail.gmail.com>
Subject: Re: [PATCH 1/5] KVM: SVM: Serialize access to the SEV ASID bitmap
To:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 3, 2019 at 2:17 PM Lendacky, Thomas <Thomas.Lendacky@amd.com> wrote:
>
> From: Tom Lendacky <thomas.lendacky@amd.com>
>
> The SEV ASID bitmap currently is not protected against parallel SEV guest
> startups. This can result in an SEV guest failing to start because another
> SEV guest could have been assigned the same ASID value. Use a mutex to
> serialize access to the SEV ASID bitmap.
>
> Fixes: 1654efcbc431 ("KVM: SVM: Add KVM_SEV_INIT command")
> Tested-by: David Rientjes <rientjes@google.com>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
