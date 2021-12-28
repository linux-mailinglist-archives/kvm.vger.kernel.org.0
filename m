Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41504480875
	for <lists+kvm@lfdr.de>; Tue, 28 Dec 2021 11:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236218AbhL1Kdk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Dec 2021 05:33:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:46232 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230112AbhL1Kdj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Dec 2021 05:33:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640687618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SBjG/a985p+cb1ubBD+U1scKESLYs9cmGWO1wAxCDW4=;
        b=bAGrSObd2XQAuIZq15Npb26mulg+d+HInGTFrxyYf/B/3UrwnR7AY0E6fGpTg6mFvsg0uQ
        ATg2Hr5AidMNPRql7QLA9Wbn5pfRKID6N5vqo8t++0QRrK+gqBJ5XEluCcxIYnVPCJ5XvO
        MtgxH04jQlHXwNMiuFpaR8o6XlQijZs=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-169-EoDW8HJ-PKq_EntP7wlD4g-1; Tue, 28 Dec 2021 05:33:37 -0500
X-MC-Unique: EoDW8HJ-PKq_EntP7wlD4g-1
Received: by mail-ed1-f69.google.com with SMTP id d7-20020aa7ce07000000b003f84e9b9c2fso12786188edv.3
        for <kvm@vger.kernel.org>; Tue, 28 Dec 2021 02:33:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SBjG/a985p+cb1ubBD+U1scKESLYs9cmGWO1wAxCDW4=;
        b=ArNyQpUsPNYgJ3XS8h6KhlXbZoMVCn+bk8O46mC/ngPa6W1/Wqw7LCxzry4EjZR4Vk
         9uSSnGkaCOzvoBdsQ0dYPt6vEP5htDxxDozO15+/b57QXN5JK5qU/nknz+YqqgXBYyrX
         jCoN6SudXI8zm6bAknqg+LT7jxgD8Yi9D83G0UjWN9w9nD5Yb6vxzYA0cOf2TyH/xA8t
         icdx7Go8pacsJ9rPWYSxRjauD8TkxcZ8RiOjhZiVbnFgSCwtMhaU5lUXAUPrb4HJqbvw
         KhG7sOmg8cJbzI1dAW40s49JmtzfYLii7elXFP52VwH3ffMfZLcBIUo3OpeXQcTBkyO/
         fsow==
X-Gm-Message-State: AOAM533EsqM//wZI8MU9w6jYNEN6J0zBtLgSfGJ5Abj/t+Wc2gExtbmX
        1v2Vkw3jMXCzPpxpnoalC6gbcRlMh3F0Bedl70gxkoMJIYB0O5iL6kFFuwYr8qN719djx6ayKAZ
        reGr4AoNgJMtq
X-Received: by 2002:a17:906:c156:: with SMTP id dp22mr16409111ejc.283.1640687616135;
        Tue, 28 Dec 2021 02:33:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJznxJ1o6y4D1qii3IBo+ZD3Ob9gcmDwntvGzoTLH2907uqCM0H93UNmHTwMNt1bk7+BIpA6sg==
X-Received: by 2002:a17:906:c156:: with SMTP id dp22mr16409100ejc.283.1640687615997;
        Tue, 28 Dec 2021 02:33:35 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id hu8sm5965559ejc.32.2021.12.28.02.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 02:33:35 -0800 (PST)
Date:   Tue, 28 Dec 2021 11:33:33 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: Re: [PATCH v2 2/6] KVM: selftests: arm64: Introduce a variable
 default IPA size
Message-ID: <20211228103333.xhyxf2nytaw7z4wy@gator.home>
References: <20211227124809.1335409-1-maz@kernel.org>
 <20211227124809.1335409-3-maz@kernel.org>
 <20211228092622.ffw7xu2j5ow4njxo@gator.home>
 <87lf05yqcw.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lf05yqcw.wl-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 28, 2021 at 10:29:35AM +0000, Marc Zyngier wrote:
> > > +		for (i = 0; vm_mode_default == NUM_VM_MODES && i < NUM_VM_MODES; i++) {
> > > +			if (guest_modes[i].supported && guest_modes[i].enabled)
> > > +				vm_mode_default = i;
> > 
> > Since we don't have a 'break' here, this picks the last supported size
> > (of the guest_modes list), not the first, as the comment implies it should
> > do.
> 
> This is checked in the for() loop condition, and the first matching
> mode will cause the loop to terminate. This is the same check that
> avoids scanning for a mode when VM_MODE_P40V48_4K is selected.
>

Ah, of course, sorry for the noise.

Reviewed-by: Andrew Jones <drjones@redhat.com>

