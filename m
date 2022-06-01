Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 336CA53A336
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 12:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344716AbiFAKtD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 06:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352576AbiFAKtA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 06:49:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AD2E1819B4
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 03:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654080532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hrH+2QAikayivhZwVSMboNGmELij4yc/hiwsqHY23jQ=;
        b=NXLtCv6kL8P6R4zsB8TxN8NFic5TKzTTB4F5+eSbOom5jbMRbstPiwj5/ZsmuJIHYTojTO
        mH75rKHtD35Q2yYmC6pBa8QGRbO0HiERr6UUPfAl0zTCtldV+tOu5+2dbDM+kEFmpnyBZF
        x83CD43lDkFz4GWZiOqMJptark9ohJY=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-478-EPaAI-8eMiSaYixEtlXjxQ-1; Wed, 01 Jun 2022 06:48:50 -0400
X-MC-Unique: EPaAI-8eMiSaYixEtlXjxQ-1
Received: by mail-pj1-f69.google.com with SMTP id il9-20020a17090b164900b001e31dd8be25so3459194pjb.3
        for <kvm@vger.kernel.org>; Wed, 01 Jun 2022 03:48:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hrH+2QAikayivhZwVSMboNGmELij4yc/hiwsqHY23jQ=;
        b=G4cqhKmvuFOH6DOlnklY1z7fR55jKRz7j1SNwabsZzYkG6odZ4TSbnkwkRrH6TRMR7
         7JrZ7+y29u+HV3SM5KnFKsj8aymP3DcRLwEUxEWeIulOMfGV+ddljHUR1wYiGZVO+M7l
         VCuGfw0R8NQlJpsv6m+1XtudO2ndX3CzWlCH9qVV1ZqP1Tx92QCDKJt7VMXXRzgqhNYu
         UXHLsr0TqnHjicMglxyt8mFHmw6ZfSGjL3y55FmzYkqLwNM8+3ifr65kLNj6trisLT+v
         mgDZYTSj1+jdtPKpdI/rRr61gkxUGcx1/FAvQYZmqYpmqsaz++9N8Wafm0Ta3zFNvANs
         BGfA==
X-Gm-Message-State: AOAM533m/HGiy6pr4sLf4a5vMUKnbhq3xzeuzWNpBz8AyM4UL6fiU4dy
        /HBAQ0mwAVriAdgpRDYDuKc43al+AaVE9SgcdoMHhBINKXZXX+ArXMu+x7G2j2+KUwuGNoSX14j
        uPAM+p1x2sxiD94vv7wEoU00jNbtM
X-Received: by 2002:a17:902:7c0e:b0:161:f9f6:be5b with SMTP id x14-20020a1709027c0e00b00161f9f6be5bmr55846793pll.156.1654080529836;
        Wed, 01 Jun 2022 03:48:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw8Z/R1QPBiL3zZ58Z7WbyHv1cLTETgAEl2rVhWxKGRnsk8bKpXpXQqWNnB+kkOIRq0CkwtBCtdW6dm6n516Mg=
X-Received: by 2002:a17:902:7c0e:b0:161:f9f6:be5b with SMTP id
 x14-20020a1709027c0e00b00161f9f6be5bmr55846774pll.156.1654080529546; Wed, 01
 Jun 2022 03:48:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220531075540.14242-1-thuth@redhat.com> <YpZu6/k+8EydfBKf@google.com>
In-Reply-To: <YpZu6/k+8EydfBKf@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Wed, 1 Jun 2022 12:48:38 +0200
Message-ID: <CABgObfZ8LipJXh28xjRxqZPyNX1muP=_fYdmH=a9hvQh7eq32w@mail.gmail.com>
Subject: Re: [PATCH] KVM: Adjust the return type of kvm_vm_ioctl_check_extension_generic()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Thomas Huth <thuth@redhat.com>, kvm <kvm@vger.kernel.org>,
        "Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 31, 2022 at 9:39 PM Sean Christopherson <seanjc@google.com> wrote:
> As for KVM_GET_NR_MMU_PAGES, my vote would be just sweep it under the rug with a
> comment and blurb in the documentation that it's broken.  I highly doubt any VMM
> actually uses the ioctl() in any meaningful way as it was largely made obsolete by
> two-dimensional paging, e.g. neither QEMU nor our VMM use it.

I think we can just remove it, or return 0.

Paolo

