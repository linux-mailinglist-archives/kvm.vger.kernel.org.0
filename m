Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9A93162CB1
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 18:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgBRR0f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 12:26:35 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:30424 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726411AbgBRR0f (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Feb 2020 12:26:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582046793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dpPv1roZppzA3wb1e8JnZr/KTikx5OJph9zB/RhUdlM=;
        b=JMWIgaiLA3aVVNbwicUWpZsuZJjvGf0cqdIj+Hlad4FgQJgL5Kml6S8PAWGhoWO/XFCIQz
        vjD6SrnjCzCkfFcrLPhcEExP0iv67K++b3Nip/xtGm3xfzp/w8n0q8C/w8L83lUV+epA0V
        7trWCnseB0m85kY9TJRqL8NmixQIJPQ=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-Yp2RbshSN7C2TZmO9wsBdw-1; Tue, 18 Feb 2020 12:26:29 -0500
X-MC-Unique: Yp2RbshSN7C2TZmO9wsBdw-1
Received: by mail-qt1-f199.google.com with SMTP id n4so13590701qtv.5
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2020 09:26:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dpPv1roZppzA3wb1e8JnZr/KTikx5OJph9zB/RhUdlM=;
        b=HbNgLRjzFbzQqy+I7SrKhrBObMLf0dNJlX42S2KsRsO65+EOYmaa6et0EAh7Ay192z
         uZEcAe6F5VmFVMUdAORdel3KLmwcqF+DSd6MLRX60XCwttD2smY7cUnIz440PLosEPO8
         b1VCi4KwfkBC88vSywUDYvbVVL43735gNvu/Lhn4/22fH/851T3rKwWpFAJXU3orgJJ0
         /siW4ew1uy5uK8lV+EY939Y1S5aMZhZhwokquFAcJDxeH+OHrBCFLRnErg3HAeyht8fj
         3Zc0Y2jHQ40jTXjyUW4hds/8F13BvP+bxtNEW4upKV3Th6V2tt0wm+/gq5TqiQ34fyiz
         zD0w==
X-Gm-Message-State: APjAAAWLyquCUUGt8rlDtJmjDZkJ5NtiiWaLd9x093+6J0pK6eKLXrNE
        1ijaG2EVMFlmzprgMea3LazyPlqEwZIa9iY4TQ665kenL5ga9F7Ba2Wo+csZwEFR5elUpROy1DB
        X1pTNzmUn1kyv
X-Received: by 2002:ad4:490d:: with SMTP id bh13mr17563514qvb.180.1582046789231;
        Tue, 18 Feb 2020 09:26:29 -0800 (PST)
X-Google-Smtp-Source: APXvYqyVIViLGBHUmNxLPTabYA7lauPrrIbw23UrceEgLdeuJQYDqs13t1scVOwZNI1bE94GlB8sJg==
X-Received: by 2002:ad4:490d:: with SMTP id bh13mr17563500qvb.180.1582046789023;
        Tue, 18 Feb 2020 09:26:29 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id p92sm2118072qtd.14.2020.02.18.09.26.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 09:26:28 -0800 (PST)
Date:   Tue, 18 Feb 2020 12:26:27 -0500
From:   Peter Xu <peterx@redhat.com>
To:     "Zhoujian (jay)" <jianjay.zhou@huawei.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "wangxin (U)" <wangxinxin.wang@huawei.com>,
        "linfeng (M)" <linfeng23@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        "Liujinsong (Paul)" <liu.jinsong@huawei.com>
Subject: Re: [PATCH] KVM: x86: enable dirty log gradually in small chunks
Message-ID: <20200218172627.GD1408806@xz-x1>
References: <20200218110013.15640-1-jianjay.zhou@huawei.com>
 <24b21aee-e038-bc55-a85e-0f64912e7b89@redhat.com>
 <B2D15215269B544CADD246097EACE7474BAF9BDD@DGGEMM528-MBX.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <B2D15215269B544CADD246097EACE7474BAF9BDD@DGGEMM528-MBX.china.huawei.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 18, 2020 at 01:39:36PM +0000, Zhoujian (jay) wrote:
> Hi Paolo,
> 
> > -----Original Message-----
> > From: Paolo Bonzini [mailto:pbonzini@redhat.com]
> > Sent: Tuesday, February 18, 2020 7:40 PM
> > To: Zhoujian (jay) <jianjay.zhou@huawei.com>; kvm@vger.kernel.org
> > Cc: peterx@redhat.com; wangxin (U) <wangxinxin.wang@huawei.com>;
> > linfeng (M) <linfeng23@huawei.com>; Huangweidong (C)
> > <weidong.huang@huawei.com>
> > Subject: Re: [PATCH] KVM: x86: enable dirty log gradually in small chunks
> > 
> > On 18/02/20 12:00, Jay Zhou wrote:
> > > It could take kvm->mmu_lock for an extended period of time when
> > > enabling dirty log for the first time. The main cost is to clear all
> > > the D-bits of last level SPTEs. This situation can benefit from manual
> > > dirty log protect as well, which can reduce the mmu_lock time taken.
> > > The sequence is like this:
> > >
> > > 1. Set all the bits of the first dirty bitmap to 1 when enabling
> > >    dirty log for the first time
> > > 2. Only write protect the huge pages
> > > 3. KVM_GET_DIRTY_LOG returns the dirty bitmap info 4.
> > > KVM_CLEAR_DIRTY_LOG will clear D-bit for each of the leaf level
> > >    SPTEs gradually in small chunks
> > >
> > > Under the Intel(R) Xeon(R) Gold 6152 CPU @ 2.10GHz environment, I did
> > > some tests with a 128G windows VM and counted the time taken of
> > > memory_global_dirty_log_start, here is the numbers:
> > >
> > > VM Size        Before    After optimization
> > > 128G           460ms     10ms
> > 
> > This is a good idea, but could userspace expect the bitmap to be 0 for pages
> > that haven't been touched? 
> 
> The userspace gets the bitmap information only from the kernel side.
> It depends on the kernel side to distinguish whether the pages have been touched
> I think, which using the rmap to traverse for now. I haven't the other ideas yet, :-(
> 
> But even though the userspace gets 1 for pages that haven't been touched, these
> pages will be filtered out too in the kernel space KVM_CLEAR_DIRTY_LOG ioctl
> path, since the rmap does not exist I think.
> 
> > I think this should be added as a new bit to the
> > KVM_ENABLE_CAP for KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2.  That is:
> > 
> > - in kvm_vm_ioctl_check_extension_generic, return 3 for
> > KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 (better: define two constants
> > KVM_DIRTY_LOG_MANUAL_PROTECT as 1 and
> > KVM_DIRTY_LOG_INITIALLY_SET as 2).
> > 
> > - in kvm_vm_ioctl_enable_cap_generic, allow bit 0 and bit 1 for cap->args[0]
> > 
> > - in kvm_vm_ioctl_enable_cap_generic, check "if
> > (!(kvm->manual_dirty_log_protect & KVM_DIRTY_LOG_INITIALLY_SET))".
> 
> Thanks for the details! I'll add them in the next version.

I agree with Paolo that we'd better introduce a new bit for the
change, because we don't know whether userspace has the assumption
with a zeroed dirty bitmap as initial state (which is still part of
the kernel ABI IIUC, actually that could be a good thing for some
userspace).

Another question is that I see you only modified the PML path.  Could
this also benefit the rest (say, SPTE write protects)?

Thanks,

-- 
Peter Xu

