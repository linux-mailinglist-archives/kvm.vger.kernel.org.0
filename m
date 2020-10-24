Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68BD5297B96
	for <lists+kvm@lfdr.de>; Sat, 24 Oct 2020 11:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760386AbgJXJNv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Oct 2020 05:13:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54107 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1760379AbgJXJNu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 24 Oct 2020 05:13:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603530829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ov3VxQngiWd+nPCyG+hdNSLhArqYN+PxKWa5kaRJbhE=;
        b=VY1Vts+5+VRuBJsOTjX/HMSL+GohvgH/8z6b0+VEZbfPGWfjwPnLTu8TsNrAw9a6vkRhdv
        r6nBuC/bM1VdXklH8nuaRe5Guqx1bfYXNP9JGtFX3KhiqdYFb/ij4VTJfijdNyy4N3NCaf
        9eYb/d0mzlKRIBiRzwxiktxYQS74oRU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-PjrGz4UwOw2gFFa0WmM3mg-1; Sat, 24 Oct 2020 05:13:39 -0400
X-MC-Unique: PjrGz4UwOw2gFFa0WmM3mg-1
Received: by mail-wr1-f70.google.com with SMTP id q15so1706968wrw.8
        for <kvm@vger.kernel.org>; Sat, 24 Oct 2020 02:13:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ov3VxQngiWd+nPCyG+hdNSLhArqYN+PxKWa5kaRJbhE=;
        b=t2uWS/2jkXBP1OenmOJL00ErX85PJGijbQNokIjTQHhQlGP+auuSg3Szh90RqHogv6
         8o7MCsfFC1ZRpMnZmO4pBYJJqtStii+BZjqLRLMqNh79+8kOqX18QC/+MMqJws3uEMt4
         Ed+YaHHMl4zQkO7lJYM68E1AUyjN+f/AREnaJAuaPYBWDjJKZvGFQ5LAkUO/ah/JcoNE
         r+QVTTF/5TBZag07Y5u43fUhH0JPpKfoS8cIJ8jGiBv1oP4cuqnkPnSJs0hsU9ZXO5Si
         oYV75IfXFHEISA3cXWRvgZHdoEidIH32RvzNeSNF4Rb/B0Vw5Affvrj7VB3eAs5eF8N1
         7bGg==
X-Gm-Message-State: AOAM5333E2O2q76PvjBdQHnUfCRBQW6M61U9PocLva9efs1Yd1AQchPU
        xr6RQ6D8ax4M8rorPAtpKT6R58JnzKKl6nctCJ72nlK23T+ivllCgjpwI9sfgdsouslGckx0rKI
        6hHMlKA39j7lp
X-Received: by 2002:a7b:c750:: with SMTP id w16mr5851189wmk.136.1603530817784;
        Sat, 24 Oct 2020 02:13:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw0oREPSHzZeWKY/+FGm9AFXXATGJjggFHPNlu36MovUNsXJ6vZkjcfz5fI7YF3ZyKsxnMDKQ==
X-Received: by 2002:a7b:c750:: with SMTP id w16mr5851175wmk.136.1603530817602;
        Sat, 24 Oct 2020 02:13:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id y206sm9365007wmd.34.2020.10.24.02.13.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Oct 2020 02:13:37 -0700 (PDT)
Subject: Re: [PATCH v2 8/8] x86/ioapic: Generate RTE directly from parent
 irqchip's MSI message
To:     David Woodhouse <dwmw2@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, Dexuan Cui <decui@microsoft.com>
References: <87y2jy542v.fsf@nanos.tec.linutronix.de>
 <C53CAD52-38F8-47D7-A5BE-4F470532EF20@infradead.org>
 <87d01863a2.fsf@nanos.tec.linutronix.de>
 <be564fccc341efa730b8cdfe18ef4d7e709ebf50.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ddf17616-04c7-9593-eae8-8e9e473ecd90@redhat.com>
Date:   Sat, 24 Oct 2020 11:13:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <be564fccc341efa730b8cdfe18ef4d7e709ebf50.camel@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/10/20 10:26, David Woodhouse wrote:
> I was also hoping Paolo was going to take the patch which just defines
> the KVM_FEATURE_MSI_EXT_DEST_ID bit² ASAP, so that we end up with a
> second patch³ that *just* wires it up to x86_init.msi_ext_dest_id() for
> KVM.
> 
> ¹ https://git.infradead.org/users/dwmw2/linux.git/commitdiff/734719c1f4
> ² https://git.infradead.org/users/dwmw2/linux.git/commitdiff/3f371d6749
> ³ https://git.infradead.org/users/dwmw2/linux.git/commitdiff/8399e14eb5

Yes, I am going to take it.

I was already sort of playing with fire with the 5.10 pull request (and
with me being lousy in general during the 5.10 development period, to be
honest), so I left it for rc2 or rc3.  It's just docs and it happened to
conflict with another documentation patch that had gone in through Jon
Corbet's tree.

Paolo

