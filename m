Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB31CFAA7D
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 07:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfKMGxd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 01:53:33 -0500
Received: from david.siemens.de ([192.35.17.14]:48903 "EHLO david.siemens.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725866AbfKMGxd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 01:53:33 -0500
X-Greylist: delayed 907 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Nov 2019 01:53:32 EST
Received: from mail2.sbs.de (mail2.sbs.de [192.129.41.66])
        by david.siemens.de (8.15.2/8.15.2) with ESMTPS id xAD6cF7e031765
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 07:38:15 +0100
Received: from [167.87.41.29] ([167.87.41.29])
        by mail2.sbs.de (8.15.2/8.15.2) with ESMTP id xAD6cEwY008709;
        Wed, 13 Nov 2019 07:38:15 +0100
Subject: Re: [FYI PATCH 0/7] Mitigation for CVE-2018-12207
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <1573593697-25061-1-git-send-email-pbonzini@redhat.com>
Cc:     Ralf Ramsauer <ralf.ramsauer@oth-regensburg.de>
From:   Jan Kiszka <jan.kiszka@siemens.com>
Message-ID: <23353382-53ea-8b20-7e30-763ef6df374c@siemens.com>
Date:   Wed, 13 Nov 2019 07:38:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <1573593697-25061-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12.11.19 22:21, Paolo Bonzini wrote:
> CVE-2018-12207 is a microarchitectural implementation issue
> that could allow an unprivileged local attacker to cause system wide
> denial-of-service condition.
> 
> Privileged software may change the page size (ex. 4KB, 2MB, 1GB) in the
> paging structures, without following such paging structure changes with
> invalidation of the TLB entries corresponding to the changed pages. In
> this case, the attacker could invoke instruction fetch, which will result
> in the processor hitting multiple TLB entries, reporting a machine check
> error exception, and ultimately hanging the system.
> 
> The attached patches mitigate the vulnerability by making huge pages
> non-executable. The processor will not be able to execute an instruction
> residing in a large page (ie. 2MB, 1GB, etc.) without causing a trap into
> the host kernel/hypervisor; KVM will then break the large page into 4KB
> pages and gives executable permission to 4KB pages.

When reading MCE, error code 0150h, ie. SRAR, I was wondering if that 
couldn't simply be handled by the host. But I suppose the symptom of 
that erratum is not "just" regular recoverable MCE, rather 
sometimes/always an unrecoverable CPU state, despite the error code, right?

Jan

-- 
Siemens AG, Corporate Technology, CT RDA IOT SES-DE
Corporate Competence Center Embedded Linux
