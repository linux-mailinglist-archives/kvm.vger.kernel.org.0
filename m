Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C40C77A70C
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 13:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730372AbfG3LfZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 07:35:25 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51127 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730369AbfG3LfZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 07:35:25 -0400
Received: by mail-wm1-f65.google.com with SMTP id v15so56835723wml.0
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 04:35:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y244Xl4lre8/Rj1RhE87snrTTBEmuS8COkuSeU6uG1M=;
        b=NiajQkcZyBbwd6AGlCPn5jNYfzArv3NfH922pm5uIiqmvq6qj/eccj3lfcCYpXH0Qw
         VXUEWSt2s6gx82hJzrQ5Fz1TcxVEu3pkE+vaRcnm4zFFqQq4on3iVM07ASIIVA+rpFoG
         0ZEDaZF+z/gmdHkKIaeslj/oIsP0bDHsg8JK4wD8QzP5r+z65MmQZLIQrDptIQs4KNFz
         6pPKrjD9Z2aXS/Sm+6NoGrgEqAOH88jkaoyBPqTzBQ9hjt9AwT0LU9LHGec/wP1sE2IK
         F94WCgZWGhBc4IoxvSpqt0G+zWPn4BndP3FTgSijuqmGzzgYXQseuAD6HTRf93GWHHSY
         JLDg==
X-Gm-Message-State: APjAAAWGXUIxLQS2oP8gVc1Hf64nG3jCUvJ7NnVU9FeIfBDHCFZBMQhe
        uUcE3bNfvZzoFqos/RjlUPeEvA==
X-Google-Smtp-Source: APXvYqzkH9Q1Qg/qmKmzEMbzb79yFSlC2/AlPs26tGR5Hv2Po5wEl1eHp6jRHjCYU18erlFW03Sryg==
X-Received: by 2002:a1c:4e14:: with SMTP id g20mr28937377wmh.3.1564486523302;
        Tue, 30 Jul 2019 04:35:23 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id s10sm72854605wmf.8.2019.07.30.04.35.21
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 04:35:22 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: selftests: Enable dirty_log_test on s390x
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Shuah Khan <shuah@kernel.org>, Peter Xu <peterx@redhat.com>
References: <20190730100112.18205-1-thuth@redhat.com>
 <20190730100112.18205-3-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3092bab6-8ab9-c404-a5bb-64ca89eccd12@redhat.com>
Date:   Tue, 30 Jul 2019 13:35:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190730100112.18205-3-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/07/19 12:01, Thomas Huth wrote:
> +#ifdef __s390x__
> +	/*
> +	 * On s390x, all pages of a 1M segment are initially marked as dirty
> +	 * when a page of the segment is written to for the very first time.
> +	 * To compensate this specialty in this test, we need to touch all
> +	 * pages during the first iteration.
> +	 */
> +	for (i = 0; i < guest_num_pages; i++) {
> +		addr = guest_test_virt_mem + i * guest_page_size;
> +		*(uint64_t *)addr = READ_ONCE(iteration);
> +	}
> +#endif

Go ahead and make this unconditional.

Paolo
