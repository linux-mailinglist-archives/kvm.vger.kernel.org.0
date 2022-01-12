Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E437848CA66
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 18:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344377AbiALRwO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 12:52:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344043AbiALRwN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 12:52:13 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F82C06173F
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 09:52:13 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id n30-20020a17090a5aa100b001b2b6509685so6284071pji.3
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 09:52:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4lOr0cO3MtfPjxOReqWS5LWG9cMBTSgs7rdN+koXOwM=;
        b=X74Qu9X/Fwr3SmVCD7qP2n9dWtLD6j7cD+7ia6lCkMQfgGTrzwjvG68ZxyCsEcD+Pd
         effSJTMx8/h8k/XLP00W0L12Uy/6Bp8YD0WvJBQwrzw1Qdh03hLZLMYASGNCAV6QSN6W
         Z+Yi00tEq+iraj0PX2/AH8XZ7TQk00ZGnoG2MUmE/UctqFp22VIpQNFP1hfroTD0EmWo
         Rk5frZk/ckQljI/6XBCljvo97zfYX6J70/muKiYVfG0XGHxxzGnmmIOxKEiUwDaki+Te
         6D6ja7NEWxoxjg3VwoaVNafs8B20Bfq+RrG0s+THZAL+aIM9RS82Gfz6Br/mzdkVRKJ5
         TDvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4lOr0cO3MtfPjxOReqWS5LWG9cMBTSgs7rdN+koXOwM=;
        b=YiTvLpUKD9qZ7bRPB0LvXHfD5cuwJQS3gL+rryAXZQY0NFzgh4yrZkxL3h0u5RB1hm
         ffoZreZ1j81DyXBWCQmDBBX0AD3osdNn9OCyVH7v8rRFmaSV9pQika3yQntsdDY6eT0O
         6LqghracPOlrgjUltYyIZ4eyt4Uk5EHVHdvsZWsaY1ECXQcf0NZVb5Q5vVz2BhcJ6Aq0
         JBKCy5wWayK34V2rUKDgFSPcZKy74qCKMyugm5xZclAO5IaMDfFzkrAMyxD8pABlbpwv
         +vr18VgTxRx0HnAZHnav7BUjEWPcFQh5gLt2XIz1lKeRLX1YhXBWDW0liVh98xmnRG9Q
         Tnnw==
X-Gm-Message-State: AOAM530+ZEyzBjjUGa8xC3HOqOCfT0vHvw6n267zmhwAamuFW3E5y9xl
        expkSnUG5mt2pJ0kGrogj+oKCg==
X-Google-Smtp-Source: ABdhPJzmVHtXXCExxXrlD6q6+Z8uAPfHE4FtJOgWfW1egZvlp1s9OzJP8s/SDJqyHmwU/foKpjTpGg==
X-Received: by 2002:a63:350c:: with SMTP id c12mr681310pga.568.1642009932842;
        Wed, 12 Jan 2022 09:52:12 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s7sm253374pfu.133.2022.01.12.09.52.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 09:52:12 -0800 (PST)
Date:   Wed, 12 Jan 2022 17:52:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, kevin.tian@intel.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] KVM: Do compatibility checks on hotplugged CPUs
Message-ID: <Yd8VSCghD3OvuGJ7@google.com>
References: <20211227081515.2088920-1-chao.gao@intel.com>
 <20211227081515.2088920-7-chao.gao@intel.com>
 <YdzTfIEZ727L4g2R@google.com>
 <20220111053205.GD2175@gao-cwp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220111053205.GD2175@gao-cwp>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 11, 2022, Chao Gao wrote:
> On Tue, Jan 11, 2022 at 12:46:52AM +0000, Sean Christopherson wrote:
> >This has a fairly big flaw in that it prevents KVM from creating VMs even if the
> >offending CPU is offlined.  That seems like a very reasonable thing to do, e.g.
> >admin sees that hotplugging a CPU broke KVM and removes the CPU to remedy the
> >problem.  And if KVM is built-in, reloading KVM to wipe hardware_incompatible
> >after offlining the CPU isn't an option.

...

> >That said, I'm not convinced that continuing with the hotplug in this scenario
> >is ever the right thing to do.  Either the CPU being hotplugged really is a different
> >CPU, or it's literally broken.  In both cases, odds are very, very good that running
> >on the dodgy CPU will hose the kernel sooner or later, i.e. KVM's compatibility checks
> >are just the canary in the coal mine.
> 
> Ok. Then here are two options:
> 1. KVM always prevents incompatible CPUs from being brought up regardless of running VMs
> 2. make "disabling KVM on incompatible CPUs" an opt-in feature.
> 
> Which one do you think is better?

IMO, #1.  It's simpler to implement and document, and is less likely to surprise
the user.  We can always pivot to #2 _if_ anyone requests the ability to dynamically
disable KVM in order to bring up heterogenous CPUs and has a reasonable, sane use
case for doing so.  But that's a big "if" as I would be very surprised if it's even
possible to encounter such a setup without a hardware bug, firmware bug, and/or user
error.
