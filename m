Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7E8434129
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 00:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbhJSWJ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 18:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbhJSWJ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 18:09:57 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C497BC06161C
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 15:07:44 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id q5so20657370pgr.7
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 15:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xs93ahHI/d8ZRpuxQaPtQL8havAooE98Ej9mp7tGATA=;
        b=DOVfWKsxwicFbklec3Xgd2QezWxbMBHVzzS1bB1A9trX1xLQdQTQc1z914huwxbqbf
         pSNypVrjkVpHQfCXIj83E5dhHIl705qwz3WcTL0G3qC5aUDZQSJM6tC19jKGn0ORxu4W
         vjS/1HlafvxmP/41Qw+s/oz6XxkFvX/FW47rUB4Bdeuk2jJ1BMDgsEEp4nEozhUcOgvl
         oqZOkdOmXSXe1a8ExqzwWKLBy0eCXtWAUJKv9FPsI1af2eVj3m1FtmsFOw/wWl8rt7hM
         p5yeSOr+uGA8qKMSxNQvUD6OTC0G496nCf8RDtZNf3TXkqnD+MnT/+GBD4hyv+IW2hqe
         xkHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xs93ahHI/d8ZRpuxQaPtQL8havAooE98Ej9mp7tGATA=;
        b=CwJYIOPSb1Jffyh8gLmWoMMm571NZBfJOkFBwRhQhDk9MjlQ0foKTYLHaFy5Rd5a0w
         amY0SBvt++F9ZWXa29PmuVlUT3oAx6K7C7GsxW4kn7WklSnmLEmA8AQnMlre5PKdrXOp
         g/HCnQ32gV5kXioHp49Sir+DlX2wE1bOO2deXSGJn0dogm5hhSgr9uVOMW06w4YCjlo4
         s49mDBid8QQYrh9sq5ahCVitaL+72dgkrQMRE8Q8w70ZmWEzswVtYPpBpGeP1v9HkRo3
         x0iUrTbnbeIz4r1fJsGz8LajqJy/pM8nHdHY2JBBNl6mD8IBHuqykq4BG1U69XDaeVRo
         Bw2Q==
X-Gm-Message-State: AOAM532rckjjO3PDgUTEndD1fX6ulk700O0pd7c70JHXDVm+IGXW8tmi
        /q6SfDm1ei3RMP7zcAt5/gk+GA==
X-Google-Smtp-Source: ABdhPJzeJ3k1toXEz+8wGgxrNpVOwRBGC04doEtFVO4un3Dnn4otKFpZ5GK0VnxcLkVW/nZBfCWYUg==
X-Received: by 2002:a05:6a00:1946:b0:44d:8136:a4a4 with SMTP id s6-20020a056a00194600b0044d8136a4a4mr2367787pfk.46.1634681264151;
        Tue, 19 Oct 2021 15:07:44 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b18sm220824pfl.24.2021.10.19.15.07.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 15:07:43 -0700 (PDT)
Date:   Tue, 19 Oct 2021 22:07:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 00/13] KVM: Scalable memslots implementation
Message-ID: <YW9Bq1FzlZHCzIS2@google.com>
References: <cover.1632171478.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1632171478.git.maciej.szmigiero@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 20, 2021, Maciej S. Szmigiero wrote:

For future revisions, feel free to omit the lengthy intro and just provide links
to previous versions.
 
> On x86-64 the code was well tested, passed KVM unit tests and KVM
> selftests with KASAN on.
> And, of course, booted various guests successfully (including nested
> ones with TDP MMU enabled).
> On other KVM platforms the code was compile-tested only.
> 
> Changes since v1:

...

> Changes since v2:

...

> Changes since v3:

...

> Changes since v4:
> * Rebase onto v5.15-rc2 (torvalds/master),
> 
> * Fix 64-bit division of n_memslots_pages for 32-bit KVM,
> 
> * Collect Claudio's Reviewed-by tags for some of the patches.

Heh, this threw me for a loop.  The standard pattern is to start with the most
recent version and work backwards, that way reviewers can quickly see the delta
for _this_ version.  I.e.

 Changes since v4:
 ...

 Changes since v3:
 ...
