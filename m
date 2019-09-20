Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2CD3B8BC5
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2019 09:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437606AbfITHsH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Sep 2019 03:48:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40352 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437593AbfITHsF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Sep 2019 03:48:05 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1D8D0C057FA6
        for <kvm@vger.kernel.org>; Fri, 20 Sep 2019 07:48:05 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id j125so821207wmj.6
        for <kvm@vger.kernel.org>; Fri, 20 Sep 2019 00:48:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GKORzqIRH8UFUe4Xtmmfu6KCmszYBGYE6BwrxWii7Vw=;
        b=SHl9rD8pNYARjP+AG7r1KC4CSVhDd+fn/trzqaj+5k6Da0UKEYS6YfPUdcHN/voUEj
         3XV0Ny4DeXOmwHTYhrMceWM+frTmROO40BsdjEytblDwTF1pqH6rpNR0duvWdkQWpHuY
         0HGc9eYh1eHhw9wPtWzq9Cshysr/iudhRYEn9maRQRW2KYTEPEFH054Ulpf6a8qzyFcI
         VeZ7BK/WkceQ8gRpA9yx+5nVhnID7Jmw/7U2xLFQlvcGRnhKQ6bc6+26uqUydkxzNQhn
         BeovI0nXXPeFFg6OqyfB2EHJiUCiZlm7gCm+YrGtO0cQwAmbQBdcRbZyYF2s1jJ3Wvao
         LAMQ==
X-Gm-Message-State: APjAAAWzU0d/Zp5jhqwP1Az2VgnP2Syd+5+FGbtBwPAqqa0QicWKRl8a
        myNGHQXXJCabKDRjqUduQVJuzJUsgxi+5S116Uosc7o0ADcNOz/91uxgEwVnxSpcECCY64RPbQa
        k56XdwpHrbDZX
X-Received: by 2002:a5d:4d42:: with SMTP id a2mr11317097wru.89.1568965683591;
        Fri, 20 Sep 2019 00:48:03 -0700 (PDT)
X-Google-Smtp-Source: APXvYqydSp1q3IPC5Ee/GOcfWjH/pT4DM0fXSnx1nHrzzgH37xFQc+n72/iPZHmbuMH5HvPeGLyqsQ==
X-Received: by 2002:a5d:4d42:: with SMTP id a2mr11317074wru.89.1568965683377;
        Fri, 20 Sep 2019 00:48:03 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c46c:2acb:d8d2:21d8? ([2001:b07:6468:f312:c46c:2acb:d8d2:21d8])
        by smtp.gmail.com with ESMTPSA id w125sm1665640wmg.32.2019.09.20.00.48.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Sep 2019 00:48:02 -0700 (PDT)
Subject: Re: [RFC 0/2] kvm: Use host timekeeping in guest.
To:     Suleiman Souhlal <suleiman@google.com>, rkrcmar@redhat.com,
        tglx@linutronix.de
Cc:     john.stultz@linaro.org, sboyd@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20190920062713.78503-1-suleiman@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <1ec0b238-61a7-8353-026e-3a2ee23e6240@redhat.com>
Date:   Fri, 20 Sep 2019 09:48:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190920062713.78503-1-suleiman@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/09/19 08:27, Suleiman Souhlal wrote:
> To do that, I am changing kvmclock to request to the host to copy
> its timekeeping parameters (mult, base, cycle_last, etc), so that
> the guest timekeeper can use the same values, so that time can
> be synchronized between the guest and the host.
> 
> Any suggestions or feedback would be highly appreciated.

I'm not a timekeeping maintainer, but I don't think the
kernel/time/timekeeping.c changes are acceptable.

Is the PTP driver not enough?

Paolo
