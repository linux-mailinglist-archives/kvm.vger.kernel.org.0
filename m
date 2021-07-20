Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E70343CF362
	for <lists+kvm@lfdr.de>; Tue, 20 Jul 2021 06:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244951AbhGTD4e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 23:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242057AbhGTD43 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 23:56:29 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5A5C061762
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 21:37:04 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id n11so10856302plc.2
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 21:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BbJ5l/mzifntQdZgcoAMozoV8xnurm7BXOSvdrIxbhg=;
        b=mq949U1s2+kAYZI0X3lgUoNXTGjhIZkrl7UOL0sPaK2QLJ/i/YLoHlNHs/Kasexq9o
         aonmjdVagasMfgKQ7UHxzTrkrwCiIIsnXbg9DfmeDxLkHUkV37XBWcNWfZj0Swx9vqWi
         ELkbuloc5D29K6er/zFevAbSakKTLFOqO24nHFIql+8yx+A8Wn06QH0MMn3AeD2dL+nb
         /IXgREyPLNTEf7yoCCZ3ltix3nR2xw2/zeoNg6ioFHOxGt5XBwvD1Kk0pA2IqKJUo75O
         23yfUcc9Eu7N1aV1wduxNTFPcCd6d70zGzujjMQMG3URPmmx+2KUYp+U0Z7mcdzLYXl6
         iBhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BbJ5l/mzifntQdZgcoAMozoV8xnurm7BXOSvdrIxbhg=;
        b=rPXHSxf2vAx9CkAW27hLfXiu68qcu3f2elvIAApBv2WjfSD2E33AO7ofhUHI5gxucX
         vN+hU/ZioIJ9R6a+xf4Ui3MNhK3qJD4lw6rMu2dlJYf1sU1Z3E4IuZlVLsBHOtL2jXmC
         PIfquzJxxvm0jqgw9dIoacLV4hZsY7YKI0h4+gEsDH65VNTOrb9dvA3kL0PSymnk1TCT
         3dEudEEgOdntpxBkFJLMIzwG/iNUPaYKXf18i479LTbzav0zdmorkyL2xDG51HV3qS9N
         kXZIVfLnFyn2LMsGmbi0gQTGsMkxYIFQN8W7ZH8AALc8oD/6225ejLBS4mwCvfrsge1a
         tZLw==
X-Gm-Message-State: AOAM530bYODZ7Us36jXg3Mxa6XauW5RTqxq+w4Tg1CyN7g3Y4NpCiMkL
        e4l+9I4XUBGxWWShOjUWQQbimXOzB0R2Q4SDtC0bIA==
X-Google-Smtp-Source: ABdhPJxVYzjLwg+WrH2DJ++AV1AOi2rqP2W42mIUyF1Blf/p9WzgLzJ4wqRstvUbJYWqQh3FCWDRx57OJD7EJ8N01dM=
X-Received: by 2002:a17:902:8484:b029:101:7016:fb7b with SMTP id
 c4-20020a1709028484b02901017016fb7bmr21740363plo.23.1626755824154; Mon, 19
 Jul 2021 21:37:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210713163324.627647-1-seanjc@google.com> <20210713163324.627647-46-seanjc@google.com>
In-Reply-To: <20210713163324.627647-46-seanjc@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 19 Jul 2021 21:36:48 -0700
Message-ID: <CAAeT=Fy_x6ziS2BE+fYigm_i-UxPyGz=QQ7yuB2HA1TtXBSD7w@mail.gmail.com>
Subject: Re: [PATCH v2 45/46] KVM: SVM: Drop redundant clearing of
 vcpu->arch.hflags at INIT/RESET
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 13, 2021 at 9:35 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Drop redundant clears of vcpu->arch.hflags in init_vmcb() now that
> init_vmcb() is invoked only through kvm_vcpu_reset(), which always clears
> hflags.  And of course, the second clearing in init_vmcb() was always
> redundant.
>
> Suggested-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thank you for removing the redundant code.

Regards,
Reiji
