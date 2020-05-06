Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0868D1C75AE
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 18:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729909AbgEFQFF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 12:05:05 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47931 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729239AbgEFQFF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 12:05:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588781104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EjQrx7huxOAEezjt1ZsltALd6iDUYrh3aKybbxhxR0E=;
        b=NJ3cssIfygfYCgqtfZVxFQudo9SFFMrtHP4WiYh1hqqt3xcJoTa1iagpbzehbe2JYcNY5R
        IylCrbLSROo06J1t/W9/LWAiVsoDCptixlx6WmJvehQPWgq27xfocL18CqJd8zuASlLwh/
        nvoUHVCZz25WUu+nQ8AeCxdf+1Y3Xd0=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-68-QhxK5l2CPwGTMfw1twTnXg-1; Wed, 06 May 2020 12:05:02 -0400
X-MC-Unique: QhxK5l2CPwGTMfw1twTnXg-1
Received: by mail-qk1-f200.google.com with SMTP id i10so2197015qkm.23
        for <kvm@vger.kernel.org>; Wed, 06 May 2020 09:05:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EjQrx7huxOAEezjt1ZsltALd6iDUYrh3aKybbxhxR0E=;
        b=SRFK0zu6xpC98t198sn43IYiDsS3heyuhENZq62+sEaiR5Kt5j466DYbh/KPSEu0uU
         o8Zo7k3pj9b26w+//q/YPM5HlLCF1YKouj30rDyClOSDSHnUmFNbY0EO/mlqbM3VGDvX
         2/RzYjwKtLAPqe74aIDgm0N8yUicCQMsFv0Virts15+PY1ToEUaz7B+friWKDeVTr/sC
         8bmSRdp8iym/QyImMutBylQWR0j8hebb36rbhvoAQ8g1hJQC2ov13ZuQUDxIlkXmAlGh
         iY0tqwNQZvcyQu/9lKN7E3TKXtWZLLDZ/royxQWZbRnFMA2DvZEclpd/P9lHPpbw3HtS
         Ylbg==
X-Gm-Message-State: AGi0PuZ/gxff6pFWF82R5Ru+ERO4SYutcFAW83LFXb1CdMAxZlAkRosz
        KFHXoRLkfvNXEL28GQos3nTdYptzyW/RyejwBc7yx6Nn8bwTYrf7a3qMgu3Qgnr+LtK/baZ8SIW
        hsXdWE3jkOOZe
X-Received: by 2002:ac8:d86:: with SMTP id s6mr8814788qti.199.1588781101565;
        Wed, 06 May 2020 09:05:01 -0700 (PDT)
X-Google-Smtp-Source: APiQypIL0UQVhBLUOOXhtquJMMHvklh7J05are5WMG2EL+1MK+mNLkdxo7ZfxFE4DNlpfNv4qdNukg==
X-Received: by 2002:ac8:d86:: with SMTP id s6mr8814772qti.199.1588781101336;
        Wed, 06 May 2020 09:05:01 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id k2sm1956414qta.39.2020.05.06.09.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 09:05:00 -0700 (PDT)
Date:   Wed, 6 May 2020 12:04:59 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 6/9] KVM: SVM: keep DR6 synchronized with vcpu->arch.dr6
Message-ID: <20200506160459.GN6299@xz-x1>
References: <20200506111034.11756-1-pbonzini@redhat.com>
 <20200506111034.11756-7-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200506111034.11756-7-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 06, 2020 at 07:10:31AM -0400, Paolo Bonzini wrote:
> Ensure that the current value of DR6 is always available in vcpu->arch.dr6,
> so that the get_dr6 callback can just access vcpu->arch.dr6 and becomes
> redundant.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

