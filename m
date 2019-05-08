Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22AAC17930
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 14:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbfEHMLw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 08:11:52 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:42101 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727612AbfEHMLw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 08:11:52 -0400
Received: by mail-wr1-f45.google.com with SMTP id l2so26911542wrb.9
        for <kvm@vger.kernel.org>; Wed, 08 May 2019 05:11:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dpPTghQfTOfW+kj++bkMDQMA39u0jojiNITdhZwYorw=;
        b=oBuHSuGqE4VLCc3fWQBPficcnZzOcL6a6CHruSbhsZHo3MmusfUJwKAKYxw90cu0qc
         U7zjadba8G792TsgIVT1el+reDewlaKh9Usvyq9wul6blAZzf9WHLGIxzLyHi/h7loXW
         xFNtM9II9gvaV0xM1D7rvSziA/fn49j6k9Kh4+Z8rzpuMz036juFTO7yjobK7+9ljpsV
         tYUhfFewI2qbqc+5b/mDvPGFu36D2aYrbnvHELO7mQCDZbnpq9sZLztyn4E2tbP6frvu
         i+umV2qAWFBxwGJ1issn3Ym9duMAkjoUVbB6MEpMYTotiBB1hADvPKpWKHAZGz7gibs0
         LbTQ==
X-Gm-Message-State: APjAAAU+kM9ONfzm0/pPlOGov0KS6IFaDNh8DvVZiQURAx2ovuQk0BTp
        25qm2gI9vfhwfbyh2zI9MSPAEQ==
X-Google-Smtp-Source: APXvYqzXWRGG+O4sPacm10H5YRs3rwm2eU9TBEyuSh+36xB3K+X9I8BBJVgoMpepEFtFSSqB9VpsSQ==
X-Received: by 2002:a5d:62cf:: with SMTP id o15mr8029292wrv.45.1557317511102;
        Wed, 08 May 2019 05:11:51 -0700 (PDT)
Received: from [10.201.49.229] (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id v189sm4261198wma.3.2019.05.08.05.11.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 05:11:49 -0700 (PDT)
Subject: Re: [PATCH 1/3] kvm: nVMX: Set nested_run_pending in
 vmx_set_nested_state after checks complete
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Aaron Lewis <aaronlewis@google.com>
Cc:     rkrcmar@redhat.com, jmattson@google.com, marcorr@google.com,
        kvm@vger.kernel.org, Peter Shier <pshier@google.com>
References: <20190502183125.257005-1-aaronlewis@google.com>
 <20190503163524.GB32628@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <10e1bbf8-ffa6-2b4f-25b2-9a17148ec19d@redhat.com>
Date:   Wed, 8 May 2019 14:11:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190503163524.GB32628@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/05/19 11:35, Sean Christopherson wrote:
> @nested_run_pending is consumed by nested_vmx_enter_non_root_mode(),
> e.g. prepare_vmcs02().  I'm guessing its current location is deliberate.

Right.  If nested_run_pending is false, for example, GUEST_BNDCFGS must
not be taken from the vmcs12.

Paolo
