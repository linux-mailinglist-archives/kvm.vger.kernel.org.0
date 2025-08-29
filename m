Return-Path: <kvm+bounces-56354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F625B3C19D
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 19:16:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8C3161C808AA
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 17:17:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5A033375D4;
	Fri, 29 Aug 2025 17:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MKarcM8G"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52FDC201033
	for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 17:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756487803; cv=none; b=LQJPq/9fRik+YEpeXq1OCjBK019C9Gz7bqdc9hMaH6kwUXXtVi6Zi4C9oAFJOJ9QHxHD+iVuolJFXo9UMK9nbkzG/LXMQ8Qo6l3oy66K9blwwC+ZEB7pFXw73qTqWmnn3k73qd7fl30R8XiMRMPpnRTe8dvHmtkDEzlCPSd4qYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756487803; c=relaxed/simple;
	bh=AClxZaCiQbaw47cDcmPgiGhzCAOe9yNQDtqHBGEELYM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mDHMKEAbEJeLRg3wBeSGj+5YQzMFP/wDagAw5gaes8KTgorX0N45J3bJS3I0sdEJqfnx4/m0ypPrgxcG/oy4RSomEls36BN33lrAV8mLTwql7BzFl6fKvx4FyntL67m2UJOuMWH4JalLDGS9hnWbFqNmuTcKAXvF9UgyziY7tfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MKarcM8G; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756487799;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OZrpBHY322rLutziMGt8H9HYz4JDiqoxrcz3ct01MK0=;
	b=MKarcM8GfwGNRFJy0II4/4gXf51hiDJTlImGzOcU2+HlJITJCqVSzKsG11x0r0Hu9H/eFW
	3CpqU6qMWsdKww0UV1LtLhZnWi3lSBPV+XJKugF035gFWmkVDNPz1k5KJ8h/RMy74O+qZq
	wuaUU5GFfTCrIspBO1JCN8Zf3k9sUEg=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-597-7yJ7pLLfOZuiryW-ab00rg-1; Fri, 29 Aug 2025 13:16:38 -0400
X-MC-Unique: 7yJ7pLLfOZuiryW-ab00rg-1
X-Mimecast-MFC-AGG-ID: 7yJ7pLLfOZuiryW-ab00rg_1756487797
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-8870938f3a9so36982239f.1
        for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 10:16:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756487797; x=1757092597;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OZrpBHY322rLutziMGt8H9HYz4JDiqoxrcz3ct01MK0=;
        b=w9PW+ZtZv86mLreNGNMf+vz8hUpZvRIdSbgwQj0IUvXszDxY+KaGFUemIoynAD+rfu
         TI99vpGAvI5kuuCVgdwIUBQEksFxoLtOhsK6kZzjupQf9xmKTAjMfUj/41J/PA5Ambe/
         1XLeUhDVd8OGkDIcwwj1VC7Kn1D0GJtifmbJk/mZVpMx/laz4qTbsnu0oXh9w0D3vFE/
         VMcCGoOM5GYATu8AUgDzqsSpmNhwrpID6SB4EIBepJUmExIcf1rLVGVOVjril654Qgpi
         qS0L2PTNuFxjOXuNjR3XZgzasaGjRf3jBQBLX+A7+cal6HPcTiT8o87oTrcvQvpe1/kA
         fcjA==
X-Gm-Message-State: AOJu0YzNcauXeE7+Rn1JbgZNukLuSUzTbUzeB5UMuMfHF3dPPap+p/ja
	DwbCmy5mah6jpgVEj/IcH17/MFJhdoOjx6D0geUi/nuiQPP7EZoB6SBS4VnSCg36ZQJucI6LYEr
	Mn1wcSveEfSCrmI9egeBn0jWbqE9wk1asiLHtunzvBFrdgG/gVyZ6Pg==
X-Gm-Gg: ASbGncujPJBkq6HpCOtF5rxcRbKkwV/UGDROxqAiqQbLs6MtoSFMi2tjdSxCSpLUkPZ
	XBLOD/0nKPGE7dBUURRZehX+06gvRTSixVX0y258o1B/2aCOMbGxtRaheHBklmZ64QszDto1cJP
	pzBAPT+/TqI4Fhj+/VRnrKQZWR7IfsWk2Bjno4Bjiy9JG1V34fsmeSg5oJtLro/paGV7brZ1AIc
	1IjElHbhbAamw7K3p3O/vnz4GQVUkNR8jvl856jD/OvWfAHdiuLiA23gBaLyJPmLGFkf0k4+jOx
	TB9+3pJ+mo54pXZI75f2jxNvE2gZOAzFtFXWdDZpM4c=
X-Received: by 2002:a05:6e02:1aa9:b0:3ee:12eb:401f with SMTP id e9e14a558f8ab-3f2be21c614mr23349085ab.6.1756487797144;
        Fri, 29 Aug 2025 10:16:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEf/Fs8EI4bu2+i68VbmkPuuZKj7x7I/ya70AiBN+TSI4+ft/NGkZO88yuTY9gb/nKxrHhjSA==
X-Received: by 2002:a05:6e02:1aa9:b0:3ee:12eb:401f with SMTP id e9e14a558f8ab-3f2be21c614mr23348795ab.6.1756487796692;
        Fri, 29 Aug 2025 10:16:36 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50d7bffc3bdsm729065173.60.2025.08.29.10.16.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 10:16:35 -0700 (PDT)
Date: Fri, 29 Aug 2025 11:16:32 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: David Matlack <dmatlack@google.com>
Cc: kvm@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>, kernel test
 robot <lkp@intel.com>
Subject: Re: [PATCH] vfio: selftests: Fix .gitignore for already tracked
 files
Message-ID: <20250829111632.2001d2a5.alex.williamson@redhat.com>
In-Reply-To: <20250828185815.382215-1-dmatlack@google.com>
References: <20250828185815.382215-1-dmatlack@google.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 28 Aug 2025 18:58:14 +0000
David Matlack <dmatlack@google.com> wrote:

> Fix the rules in tools/testing/selftests/vfio/.gitignore to not ignore
> some already tracked files (.gitignore, Makefile, lib/libvfio.mk).
> 
> This change should be a no-op, since these files are already tracked by git and
> thus git will not ignore updates to them even though they match the ignore
> rules in the VFIO selftests .gitignore file.
> 
> However, they do generate warnings with W=1, as reported by the kernel test
> robot.
> 
>   $ KBUILD_EXTRA_WARN=1 scripts/misc-check
>   tools/testing/selftests/vfio/.gitignore: warning: ignored by one of the .gitignore files
>   tools/testing/selftests/vfio/Makefile: warning: ignored by one of the .gitignore files
>   tools/testing/selftests/vfio/lib/libvfio.mk: warning: ignored by one of the .gitignore files
> 
> Fix this by explicitly un-ignoring the tracked files.
> 
> Fixes: 292e9ee22b0a ("selftests: Create tools/testing/selftests/vfio")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202508280918.rFRyiLEU-lkp@intel.com/
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
> Note, this is on top of the vfio/next branch so I'm not sure if the hash
> in the fixes tag is guaranteed to be stable. It might be simpler to
> squash this into commit 292e9ee22b0a ("selftests: Create
> tools/testing/selftests/vfio") before sending the pull request to Linus.
> 
>  tools/testing/selftests/vfio/.gitignore | 3 +++
>  1 file changed, 3 insertions(+)

Applied to vfio next branch for v6.18.  Let's consider the commit
hashes sufficiently stable for now.  In the off chance that I need to
back something out, I can fix them.  I think it's useful for the log
to have the fixes separate, as evidenced by being able to reference
Sean's similar fix.  Thanks,

Alex


