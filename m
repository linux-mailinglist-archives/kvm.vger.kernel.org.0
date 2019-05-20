Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7180B237BA
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 15:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731409AbfETNDP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 09:03:15 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]:34389 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730506AbfETNDO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 09:03:14 -0400
Received: by mail-wr1-f50.google.com with SMTP id f8so8118055wrt.1
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 06:03:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EBtu0kPVDPNqfoCk67LhqasrzxQ+hshLRECRuXHeL70=;
        b=EegKiL5KZx+S67/q2+9Ixi6FYlZgxi6fzeb5vzNwU4W2ZA4hBHI/qQtRUw2NUkU0wL
         PqbseGLW+dBiTCGyTMh7Lv210N3s+TSQlWqjjpDbQoV6cCmh4hgNsCBlRy2xB4N/+93a
         stBNehDKM3gCPb0X5td5LQhx4TaUCzIZt9bf1/P0UK9kdO2wZH128LgTBkxffOLF0wQF
         F2oLtsUGfl4WTRhFVYOIOmNLBD0BQjCZsNHs5My+zGb/ZJRKFh92cf0gsKPPfX2gOyW6
         kLmBimT49wrki6HV7IqzJNxZSiD0pW/6qWBOjgL/rHAytLZq6Jpj/d5/ZHfxGp0ewRwY
         mJow==
X-Gm-Message-State: APjAAAXLGZw8QO6K1HqYhh9eNG9hTDL2w8cjvhMW2VIKDu0AU6gIhcOK
        cArZzqvMYXRSPuUe2W4GYaICqQ==
X-Google-Smtp-Source: APXvYqxlKJc+iUvRpyjiosiwyPtlmi7VRgY3lWLVYukOSTDRh1LbA6BHR+K0oaUwJMV2TuQzCbIFhw==
X-Received: by 2002:adf:e2c7:: with SMTP id d7mr9488238wrj.272.1558357393380;
        Mon, 20 May 2019 06:03:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac04:eef9:b257:b844? ([2001:b07:6468:f312:ac04:eef9:b257:b844])
        by smtp.gmail.com with ESMTPSA id s127sm18174505wmf.48.2019.05.20.06.03.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 06:03:12 -0700 (PDT)
Subject: Re: [PATCH] KVM: lapic: Reuse auto-adjusted timer advance of first
 stable vCPU
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <kernellwp@gmail.com>
References: <20190508214702.25317-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3ea5ae51-89b2-ee0c-d156-88198af90b95@redhat.com>
Date:   Mon, 20 May 2019 15:03:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190508214702.25317-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/05/19 23:47, Sean Christopherson wrote:
> +
> +		/*
> +		 * The first vCPU to get a stable advancement time "wins" and
> +		 * sets the advancement time that is used for *new* vCPUS that
> +		 * are created with auto-adjusting enabled.
> +		 */
> +		if (apic->lapic_timer.timer_advance_adjust_done)
> +			(void)cmpxchg(&adjusted_timer_advance_ns, -1,
> +				      timer_advance_ns);

This is relatively expensive, so it should only be done after setting
timer_advance_adjust_done to true.

Paolo
