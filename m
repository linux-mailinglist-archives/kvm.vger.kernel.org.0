Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24C8BC3A66
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 18:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729428AbfJAQWV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 12:22:21 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:36999 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbfJAQWV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 12:22:21 -0400
Received: by mail-io1-f67.google.com with SMTP id b19so21401486iob.4
        for <kvm@vger.kernel.org>; Tue, 01 Oct 2019 09:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dXNaMNmjtn4NoKzEU4YWwtpr0/6cJZfo273CrW3q6Gg=;
        b=jXdKJMIZAWFRzKgdN9aFQkqUsURR2YsZirg4dujYIwRC1wDFXpHET9PuBKwK+uRiky
         DD9n4lv0iUuAAwclF4wvcpkMS2WqoxFdvH1ecKEVSLbkD+TuC1Dc8Y2QjWbK6cKQgOU7
         5Aate0mJ3+h2DIfN9bhktLa0Jt8V0zIsOnsQCzgkZWm2a9eLJJql/4YwO2m/w/YcFT9E
         Ynvqa6jm+KISNoTTdYWztunKYklUfB6PBMAuA+OhhoXCqOj5mcaQinzt2MbIL7hyhRdN
         2aru3M092T2AqCcPX8qVFNnNLi5cxAYiPE4nluJNY/0axOsbSN9n3Zl9r9Up5/OqD7x5
         o6cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dXNaMNmjtn4NoKzEU4YWwtpr0/6cJZfo273CrW3q6Gg=;
        b=ACeL1c3prGMkPgonpOG3uXXu6Nc7XO4QlqoD6RGYsHz326dELYYcBxkFw+B7/yNmVe
         pfgdw1D/cL67k+UYt/yJ3rxcG5zXdMDTO/E+IYA63OLUTwfTeyc5kFAgLFlAVHFViY6K
         WSMtn90oFTHqwyaAQkQrvkjUNvYGQdmEGPc9L0s0jkrYIw1OicEK7CBoDb2B3oKSQ/sW
         lXN4CmQ762azRBmE7wuk7u+ePmS1ceo01RJfppLp3873KEgLFXXUXRLygDpf230vufSR
         zTlILxfd87wnTGijMqjHD90z294abFuTV4YhtgVL4I1s56Azo7lMN3Uli4dtasqypgn6
         RIAw==
X-Gm-Message-State: APjAAAUXMxHKMjL/PuZ8/3iyMgRUyIiZWiFY+M23vxjbMBJdUGl2u+7S
        DBKF8/GS64FNhRbFpeaNLWLe35vzBUSqBp3o6/3rmQ==
X-Google-Smtp-Source: APXvYqySOWAr+9rn/o6imKuZ99vcU7FkL/WkX1yccQllVF3lx+GQ3WXtY5mZHaxSE5Rjs3w1Gr0fpmySDLesdIFOeRU=
X-Received: by 2002:a92:5a10:: with SMTP id o16mr27666716ilb.296.1569946939578;
 Tue, 01 Oct 2019 09:22:19 -0700 (PDT)
MIME-Version: 1.0
References: <20191001005408.129099-1-liran.alon@oracle.com>
In-Reply-To: <20191001005408.129099-1-liran.alon@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 1 Oct 2019 09:22:08 -0700
Message-ID: <CALMp9eSTKo6bxbOU+Uwbw1ei+cpUX2CjULUTtaP7OWM-hv-RyA@mail.gmail.com>
Subject: Re: [PATCH] KVM: VMX: Refactor to not compare set PI control bits
 directly to 1
To:     Liran Alon <liran.alon@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 30, 2019 at 5:54 PM Liran Alon <liran.alon@oracle.com> wrote:
>
> This is a pure code refactoring.
> No semantic change is expected.
>
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
