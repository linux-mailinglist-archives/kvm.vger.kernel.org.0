Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1F82F8CA7
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 11:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725954AbfKLKTw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 05:19:52 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:46705 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725865AbfKLKTw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Nov 2019 05:19:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573553990;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=7i9+SK3hpwTsCv7dTE1Okd0YAcSg1MeSopDF9z7WqQ4=;
        b=E/FRsRY+a+zmVIDrlVpVv5EtwTIHd3ErF8fmz6odUQZkTzA/bDKxztA5FqfmgC7xqnszVU
        0Y099OJRYObGtkDgwvB0f9/7yCiyLvZkLzPEr7UXFYNjAhyem+/DxUsMctaWyVjte/630C
        YuYjZ9P7tSvVw+S4fhfNeRNY8seoMKQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-_yuS4JlvOwudZsfrt0QQ_w-1; Tue, 12 Nov 2019 05:19:46 -0500
Received: by mail-wm1-f72.google.com with SMTP id d140so1202046wmd.1
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2019 02:19:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YFkdWT01jyLgEtqFcC61NZ98AMX6STuxDrkyGOC4EK0=;
        b=JGRZRYcxAllWUiBsslB/pTqp+5uiSnnf4dCp9e76AoNi46i0AW84wvXdbD8OE6zPDM
         yPIbnXEKayodaN8smVssUZx9l5mrFzwCC2fdJfGf4S+hCRGqhlTVwPHTt/xWL8j6AHDX
         eonn+0fOfUOWIAINoHDmo9vWXhg988z4qP5e07u3mZf5kgFvfpyeYjs/nETs51dgCVNu
         P0+v4y/tvaGRl0Ex1T5bbgKgCxOfQni3q8uDVUKCYBEVDMGs0AZMXCWpRf3/1imQhV5c
         WZw4VHrUBcZLmpYCJ3gkQN0r4jDSRt60V99+Z1fZ3avbVdDvswZ3Ule8OGWtBzxzDvdg
         fzgA==
X-Gm-Message-State: APjAAAVYPaNxWkjU+Fs5SBXE76VsG+u0K7FpxKRUk6wwiJ7dv2gXMlbB
        HzAjMzbmBQPFQLh6KEJkt/+ndTy1oyVLP5U+FcbolfnLooEI8nM1cFvxkgZTS1xERdL06T3JqCS
        dUGgebMquOjkJ
X-Received: by 2002:a7b:c38c:: with SMTP id s12mr3334683wmj.84.1573553985546;
        Tue, 12 Nov 2019 02:19:45 -0800 (PST)
X-Google-Smtp-Source: APXvYqyPXIlM2Wpb56oH3XhullKKBX2spmK2zk1Sp2fiUJ3jnWYwlEaUB3yJIwf8L4roR2PgBk5NiQ==
X-Received: by 2002:a7b:c38c:: with SMTP id s12mr3334655wmj.84.1573553985266;
        Tue, 12 Nov 2019 02:19:45 -0800 (PST)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id f67sm3314680wme.16.2019.11.12.02.19.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2019 02:19:44 -0800 (PST)
Subject: Re: [PATCH 1/2] KVM: MMU: Do not treat ZONE_DEVICE pages as being
 reserved
To:     Dan Williams <dan.j.williams@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, KVM list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Adam Borowski <kilobyte@angband.pl>,
        David Hildenbrand <david@redhat.com>
References: <1cf71906-ba99-e637-650f-fc08ac4f3d5f@redhat.com>
 <CAPcyv4hMOxPDKAZtTvWKEMPBwE_kPrKPB_JxE2YfV5EKkKj_dQ@mail.gmail.com>
 <20191106233913.GC21617@linux.intel.com>
 <CAPcyv4jysxEu54XK2kUYnvTqUL7zf2fJvv7jWRR=P4Shy+3bOQ@mail.gmail.com>
 <CAPcyv4i3M18V9Gmx3x7Ad12VjXbq94NsaUG9o71j59mG9-6H9Q@mail.gmail.com>
 <0db7c328-1543-55db-bc02-c589deb3db22@redhat.com>
 <CAPcyv4gMu547patcROaqBqbwxut5au-WyE_M=XsKxyCLbLXHTg@mail.gmail.com>
 <20191107155846.GA7760@linux.intel.com>
 <20191109014323.GB8254@linux.intel.com>
 <CAPcyv4hAY_OfExNP+_067Syh9kZAapppNwKZemVROfxgbDLLYQ@mail.gmail.com>
 <20191111182750.GE11805@linux.intel.com>
 <CAPcyv4hErx-Hd5q+3+W6VUSWDpEuOfipMsWAL+nnQtZvYAf3bg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <e6637be8-7890-579b-8131-6fdbbd791fa0@redhat.com>
Date:   Tue, 12 Nov 2019 11:19:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hErx-Hd5q+3+W6VUSWDpEuOfipMsWAL+nnQtZvYAf3bg@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: _yuS4JlvOwudZsfrt0QQ_w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/11/19 01:51, Dan Williams wrote:
> An elevated page reference count for file mapped pages causes the
> filesystem (for a dax mode file) to wait for that reference count to
> drop to 1 before allowing the truncate to proceed. For a page cache
> backed file mapping (non-dax) the reference count is not considered in
> the truncate path. It does prevent the page from getting freed in the
> page cache case, but the association to the file is lost for truncate.

KVM support for file-backed guest memory is limited.  It is not
completely broken, in fact cases such as hugetlbfs are in use routinely,
but corner cases such as truncate aren't covered well indeed.

Paolo

> As long as any memory the guest expects to be persistent is backed by
> mmu-notifier coordination we're all good, otherwise an elevated
> reference count does not coordinate with truncate in a reliable way.
>=20

