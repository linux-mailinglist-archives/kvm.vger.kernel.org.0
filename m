Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B84863888D8
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 09:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234442AbhESIAE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 04:00:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36356 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231185AbhESIAE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 May 2021 04:00:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621411124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hUKCkP4yfMCr/BxCyU0FR0t8N/b+HPDBhjsTQZT8gMo=;
        b=EWIeO8TkEvQf+FF8z/pj5iCE90But4rjokTwJHvj2bOooy0utKfDFSzyrVYPH4C7RBxoVi
        1sBG+jqMtn28rVRVWblDaHt5UUdTPYNz52v/fS18eXRn2m5egXz2iBpgTDy5kUqEacIZZN
        ntQELpQayY+j2Ac2q+d+0vFkiEtsXBY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-gHeQdbkaOSKc4RCFJGOOLw-1; Wed, 19 May 2021 03:58:42 -0400
X-MC-Unique: gHeQdbkaOSKc4RCFJGOOLw-1
Received: by mail-wr1-f72.google.com with SMTP id d12-20020adfc3cc0000b029011166e2f1a7so5827652wrg.19
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 00:58:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=hUKCkP4yfMCr/BxCyU0FR0t8N/b+HPDBhjsTQZT8gMo=;
        b=G5l5TThva9MgJdonV5sd1qeOkf4EhMZtSWHUWtyHbfDZpVQ6ikWafA5K+QKd1lrlki
         WUWsVeCWy9T64qSuAIP6lCL1S0QnOL10K26UeoMxjpJhJp+qr+lRqk3hV3aPYT9bHruI
         AM7Yhq6rZ0UJgXmaAqQCuV1ycWKul4Ps3ABOYnpb1TRsRJ53dXPNMlpT+FAvA3h32ZuR
         /Z9reqXH2efTDOsZLse/Fau57OplddlqG80XP6YSAUOj6BAT5cepdHoQSxcJsa4s9pCM
         SAka56C6brcjHCrmFcL8UV6WYu2tM2GsF4uiD19xJ6sha5CIqZdOZ/t33AB8UjvEOy/M
         rhSQ==
X-Gm-Message-State: AOAM530T39Cr/zGp1LJ5SRglXWxZlfsJN5PXSgYL5BRu2V9SXpWSYPTA
        5OfnxgSl4J8a4NOnc2Co+EpfWk94V3rL+qWCQ+qqHXszVGWv1WE7xGXsGFxV3VGZh7E03R2vXV0
        WL7W1/bBDiVra
X-Received: by 2002:adf:ee44:: with SMTP id w4mr12459890wro.415.1621411121394;
        Wed, 19 May 2021 00:58:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyGJPlUnhk9Zw0RyKtb0dmzV6Y0MYPLqenVcZP9Fuedvj5kMpJoPZsfmnJ0kzNmVU5dehp1YQ==
X-Received: by 2002:adf:ee44:: with SMTP id w4mr12459866wro.415.1621411121166;
        Wed, 19 May 2021 00:58:41 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id x8sm24384081wrs.25.2021.05.19.00.58.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 00:58:40 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Kechen Lu <kechenl@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/5] KVM: x86: Use common 'enable_apicv' variable for
 both APICv and AVIC
In-Reply-To: <YKQmG3rMpwSI3WrV@google.com>
References: <20210518144339.1987982-1-vkuznets@redhat.com>
 <20210518144339.1987982-4-vkuznets@redhat.com>
 <YKQmG3rMpwSI3WrV@google.com>
Date:   Wed, 19 May 2021 09:58:39 +0200
Message-ID: <87r1i3jgsw.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Tue, May 18, 2021, Vitaly Kuznetsov wrote:
...
>> +	/* 'enable_apicv' is common between VMX/SVM but the defaults differ */
>
> -1 for not throwing Jim under the bus :-)

I bought the 'messenger' argument :-)

>
> Nits aside,
>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
>

Thanks!

-- 
Vitaly

