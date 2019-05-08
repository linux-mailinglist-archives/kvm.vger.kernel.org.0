Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E83C71790E
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 14:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbfEHMHF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 08:07:05 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33695 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727586AbfEHMHF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 08:07:05 -0400
Received: by mail-wr1-f68.google.com with SMTP id e11so13821044wrs.0
        for <kvm@vger.kernel.org>; Wed, 08 May 2019 05:07:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jRev/tfmL4dwnepIHA41LHL+UN/4L814xmRvA6EaEZ0=;
        b=RKCJdhHZoWBPyuo3b2bCeItxqJ78KJFRrL7EZ9Qy61HyzphIsredUf9GyqR1zg2Mpd
         lUBp3m2kO8VPSMarsk0aY2V986ohKeXa6CZ+dpGCBsfj2txjLHQjNArtaUiYJLP209RS
         mY5ae9MMqC8DQKyq5K1WcH0G1x2zmY96D+p5zlXVgZUH9QlH4EmfOvS1KpKhwu71MMMB
         lCRPz2JTCboSc1Jn2TVUoUblLDJfZQVgBkppz6i/KGucU7A1qKUk9K/X0UwYSFqg4rrU
         mkM7DNWISaX0PFJwC1JZcZt5xQvYqJu2IoGDqWDWJ6vm57DEan2eu6t99ZdAaGSvyJLD
         YzTw==
X-Gm-Message-State: APjAAAWBl8IC/lCyn5rhwLJ1hM09JDD9Hz5tYYGijYSUEsZ5ENc3CRcy
        u3v4hvvYjHQgj4dnx07MSok0PA==
X-Google-Smtp-Source: APXvYqw/cDXTK2OSP0SrpP+1wAXyNPEJMr1YkkyMcypLx2/cIVf39ON6SXIGO9Jl6TN3eaIg8jZDPQ==
X-Received: by 2002:adf:eb8e:: with SMTP id t14mr5358227wrn.113.1557317224182;
        Wed, 08 May 2019 05:07:04 -0700 (PDT)
Received: from [10.201.49.229] (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id b12sm29347811wrf.21.2019.05.08.05.07.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 05:07:03 -0700 (PDT)
Subject: Re: [PATCH 3/3] tests: kvm: Add tests for KVM_SET_NESTED_STATE
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Aaron Lewis <aaronlewis@google.com>
Cc:     rkrcmar@redhat.com, jmattson@google.com, marcorr@google.com,
        kvm@vger.kernel.org, Peter Shier <pshier@google.com>
References: <20190502183141.258667-1-aaronlewis@google.com>
 <20190503164422.GC32628@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8c3afba8-26ad-f14b-ea53-87af32fd755f@redhat.com>
Date:   Wed, 8 May 2019 14:07:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190503164422.GC32628@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/05/19 11:44, Sean Christopherson wrote:
> Hmm, probably better to check KVM_CAP_NESTED_STATE.  If/when support for
> AMD is added it'd be good to automatically pick up whatever testing we can.
> As a bonus it'll test the cap code.
> 

Fixed like this:

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
index 5eea24087d19..61a2163cf9f1 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
@@ -225,6 +225,11 @@ int main(int argc, char *argv[])
 	struct kvm_nested_state state;
 	struct kvm_cpuid_entry2 *entry = kvm_get_supported_cpuid_entry(1);
 
+	if (!kvm_check_cap(KVM_CAP_NESTED_STATE)) {
+		printf("KVM_CAP_NESTED_STATE not available, skipping test\n");
+		exit(KSFT_SKIP);
+	}
+
 	/*
 	 * AMD currently does not implement set_nested_state, so for now we
 	 * just early out.

Paolo
