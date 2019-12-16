Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F37C6120EC6
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 17:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbfLPQFb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 11:05:31 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:33104 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbfLPQFa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 11:05:30 -0500
Received: by mail-qk1-f196.google.com with SMTP id d71so3759772qkc.0
        for <kvm@vger.kernel.org>; Mon, 16 Dec 2019 08:05:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+lKQBDpzDPcg15QBEHobBzdq4ppx02T+T0NScAe4/rA=;
        b=QsIADyvzRl9qoNxQVFr7adBzvQjOsTJR7jI2oGaHKBK2GYda2oFKhnUM4xsOl/UMeZ
         bv3vJ75KMRCZfpDFk0zrSDBcVzpxUeN9Re6zIr5fB/AhTVSxcq5SWQyxUXf1VhA3JQ38
         OtXjHCD7meb2uorDQ4B8xW1i0pURq1ZiCyEKVoudzSWAC7/ETU95NvFX161h2xTesLtu
         4CKCXS25EHzRA2iiyARcykUTfWjbc8j7uq0YAG6OfWm3eSPsxturRhZ1hQmkFlcMsE+k
         THvZZRA5PRenWMpOZSycSBezhCZaOOfS/SpDxP7Y8oey3DrqEVkfsXSpow6ryeiYCngM
         HWFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+lKQBDpzDPcg15QBEHobBzdq4ppx02T+T0NScAe4/rA=;
        b=qhKmvfV8EzKqPih+ElG1mPEH/uhFJTq5c9a2MHkvv4tm7D2p1VcGHXLKAfoYcMh7wm
         GkQhK8xvB/dSvXP2ZmvoZQ1mw8dibvIr3lGHmvua9qzn+4WHbfhPKwTrMml6L1KQigol
         EmGMAAUhkxF3Y2dW4XS71rgsIg6FRLNlE9Tm0YIZHUHwkBzfutDggtFcL3JP4OqfprpF
         tDLQ0M9myQklSM9EeqKPoJ9N/YqRjmwrHrHjlod/HuLYr5DHTgq5dhkC9cCRlFDu+Kiq
         p62jWfk/Oj9U32Gx9NTHwPrFuo+N5HB28KGWmsyI0VkShARPGFmtG8Nv/cRmo4xJikVM
         gwKg==
X-Gm-Message-State: APjAAAUJDWDXW1vBsO9TNqjN4dGD5Aq4oTfDlYNOXP6WrxLr5Zrwv71D
        52nXLMFBd5/XANy91VtyfIBm7w==
X-Google-Smtp-Source: APXvYqwzTOp0qWhlavl8UpEOrZOd6WkqWpFywuJjzXs13a42ZVBjXmBZSsWQfNbKB9CjvluM06GlvQ==
X-Received: by 2002:a37:6d5:: with SMTP id 204mr25587692qkg.448.1576512328086;
        Mon, 16 Dec 2019 08:05:28 -0800 (PST)
Received: from ?IPv6:2620:0:1004:a:6e2b:60f7:b51b:3b04? ([2620:0:1004:a:6e2b:60f7:b51b:3b04])
        by smtp.gmail.com with ESMTPSA id r37sm6992733qtj.44.2019.12.16.08.05.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 08:05:27 -0800 (PST)
Subject: Re: [PATCH v5 2/2] kvm: Use huge pages for DAX-backed files
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        linux-nvdimm@lists.01.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jason.zeng@intel.com
References: <20191212182238.46535-1-brho@google.com>
 <20191212182238.46535-3-brho@google.com>
 <06108004-1720-41EB-BCAB-BFA8FEBF4772@oracle.com>
 <ED482280-CB47-4AB6-9E7E-EEE7848E0F8B@oracle.com>
 <f8e948ff-6a2a-a6d6-9d8e-92b93003354a@google.com>
 <65FB6CC1-3AD2-4D6F-9481-500BD7037203@oracle.com>
 <20191213171950.GA31552@linux.intel.com>
From:   Barret Rhoden <brho@google.com>
Message-ID: <e012696f-f13e-5af1-2b14-084607d69bfa@google.com>
Date:   Mon, 16 Dec 2019 11:05:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191213171950.GA31552@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/13/19 12:19 PM, Sean Christopherson wrote:
> Teaching thp_adjust() how to handle 1GB wouldn't be a bad thing.  It's
> unlikely THP itself will support 1GB pages any time soon, but having the
> logic there wouldn't hurt anything.
> 

Cool.  This was my main concern - I didn't want to break THP.

I'll rework the series based on all of your comments.

Thanks,

Barret


