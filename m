Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE34DE605
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2019 10:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbfJUIMu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 04:12:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53762 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727047AbfJUIMu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 04:12:50 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6CE4786662
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 08:12:50 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id o188so5540877wmo.5
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 01:12:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iMBlsmTbyc1by6UD9+Cjcv74kSZEU4gLAG9XLb3vXMM=;
        b=W/XkUy0ITwDDQpbEFAaJZDxt1i4sjbYmihYy1WTaddNqEh42kbIKhWBJSWnRpIzrw3
         UiK9D+2CW/nvMTBO7UVA+Ogacqbxqw+v8KA8vj3mAgCsIfDBYIsc9llWJbM2WFIkrS30
         uFc1l01PP3AZv1XqM0Mcne6gBrI6LvxkNtFepXyGBK6J9HFgxqvzkhA3nWn/nf3AMnWA
         AcqgdnmDRtF9YHMritOgyUHJxjv02lgIsSRqrdgMDc773SsivMkVjF+jp2iaAq49eJO2
         0Wh0c1W5coZeYRyXRBdfxcRzq98N/8gmVZWfX46TKkyo6VVI+6tPu2bT6ANXpmYcQdvM
         ZjTA==
X-Gm-Message-State: APjAAAVDWNJCpbijRpU/+x3MCN4OQ/L/9cVJDKD8cktC+DHPGNbQvI+j
        Ef7QHxKMupFuXB/U9OHSwvTlwphPYY3j5AmzMV2NHINuAVhRGHBq+pGLlZu9PKBs7sVWx1ZxvsI
        5WvbFm5qajE5N
X-Received: by 2002:a05:600c:2503:: with SMTP id d3mr19263026wma.44.1571645568971;
        Mon, 21 Oct 2019 01:12:48 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx9/+OXOzpeQV7Ni65kLbXS9IKEOhkhFOGoxsIe0Y4dR3AU7giY9RU0QnZvv+DPO6xdA+wWEw==
X-Received: by 2002:a05:600c:2503:: with SMTP id d3mr19262990wma.44.1571645568652;
        Mon, 21 Oct 2019 01:12:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:566:fc24:94f2:2f13? ([2001:b07:6468:f312:566:fc24:94f2:2f13])
        by smtp.gmail.com with ESMTPSA id x7sm16385365wrg.63.2019.10.21.01.12.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2019 01:12:48 -0700 (PDT)
Subject: Re: [PATCH v2 3/4] KVM: x86/vPMU: Reuse perf_event to avoid
 unnecessary pmc_reprogram_counter
To:     Like Xu <like.xu@linux.intel.com>, kvm@vger.kernel.org,
        peterz@infradead.org, Jim Mattson <jmattson@google.com>
Cc:     rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        ak@linux.intel.com, wei.w.wang@intel.com, kan.liang@intel.com,
        like.xu@intel.com, ehankland@google.com, arbel.moshe@oracle.com,
        linux-kernel@vger.kernel.org
References: <20191013091533.12971-1-like.xu@linux.intel.com>
 <20191013091533.12971-4-like.xu@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5020e826-e461-c28a-0b40-6e00aaa28163@redhat.com>
Date:   Mon, 21 Oct 2019 10:12:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191013091533.12971-4-like.xu@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Just a naming tweak:

On 13/10/19 11:15, Like Xu wrote:
> +	/* the exact requested config to create perf_event */
> +	u64 programed_config;

	/*
	 * eventsel value for general purpose counters, ctrl value for
	 * fixed counters.
	 */
	u64 current_config;

