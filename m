Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C07A2FCF28
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 21:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbfKNUJQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 15:09:16 -0500
Received: from mail-io1-f50.google.com ([209.85.166.50]:41174 "EHLO
        mail-io1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726474AbfKNUJQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 15:09:16 -0500
Received: by mail-io1-f50.google.com with SMTP id r144so8230629iod.8
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 12:09:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=59gbO9ngFb6JvwATZjaBOelFU6+24q0SZznXt/ht4Kg=;
        b=gQKm07Ewcw27MfDJL4zk3eMDGWn9oRP3nHDsBGN6u1EBbkfxxGSrGk9GWQ+VDrZfRY
         sAE1kMOQhDIbSWqZ3dQCf63Z935b1CFB/CtWgLdhrEBu3EldSdIjqxF0aIAdgdQK0eUl
         iCgGKR9NOw3VFy++eHq/sRS+3JNYuD3QkAJXvIv//XA5AAKj4YvDPpGomRP4N8jaRUG+
         yX/ssA9Bdz8lVZKa5rdT14q/ZnqsVyNx99trHPBfHMJbXLUatnPJA4cmV39+2HybdoXS
         6lTWbkXbrCYnxiPrj8s1FyGpmSFglZYSZ6zPZAY+73T+bTgcGwRngl1sEuZrnZEeJtda
         VDkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=59gbO9ngFb6JvwATZjaBOelFU6+24q0SZznXt/ht4Kg=;
        b=iNDeeWyFOB3kHi+16IbvwfpxCfkLFKIigV9gHVGg+coRO3E+LSQfi0A6uxeptYyb1r
         UIPt00jtw2RIEixg+sNiOarI/5I33TE3LbSE6V+nttbMvxLPCiGfYOU7dXIV2I+EG7RY
         Qjc9XFTIsJ1svhLYdWZzSlT1j4XSBA3fQ5CjWpASBJR7NI32GUCrZPnoF9ZGF6WQgeIO
         LUcuvl4Dedx8XRXt8C/jSJh4h/SwezqAgMtOIZlZ39J/YgycPCP3ieZLQbuRFHvDmsxZ
         k+GlbbUMBsteyo7qpyIcl7MxiSY+0Aiw1WsJ2mF2a8Geopb/oj3k0t2Izl3rjqa39iyO
         YwjQ==
X-Gm-Message-State: APjAAAVuriqTc+R8JUo3CsSgfylK4W3FiF7o9viqqsvPJlYO89wecWW5
        8tHWOUDCoPyVDGXV6LWrZRhCuJjSEzOwFgs5C2tYaEfy/Zk=
X-Google-Smtp-Source: APXvYqxr5fhqs8s4GTovb525ntP8fk3MSd+Q3UVXTO7hbZL8w+5BuBZ89aE+XT1bM51WFPdi+PJ6GjglnZpdBJ+abac=
X-Received: by 2002:a02:40c6:: with SMTP id n189mr9517269jaa.18.1573762154821;
 Thu, 14 Nov 2019 12:09:14 -0800 (PST)
MIME-Version: 1.0
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 14 Nov 2019 12:09:03 -0800
Message-ID: <CALMp9eQ3NcXOJ9MDMBhm2Fi2cvMW7X5GxVgDw97zS=H5vOMvgw@mail.gmail.com>
Subject: KVM_GET_SUPPORTED_CPUID
To:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Can someone explain this ioctl to me? The more I look at it, the less
sense it makes to me.

Let's start with leaf 0. If I see 0xd in EAX, does that indicate the
*maximum* supported value in EAX? Or does that mean that only a value
of 0xd is supported for EAX? If I see "AuthenticAMD" in EBX/EDX/ECX,
does that mean that "GenuineIntel" is *not* supported? I thought
people were having reasonable success with cross-vendor migration.

What about leaf 7 EBX? If a bit is clear, does that mean setting the
bit is unsupported? If a bit is set, does that mean clearing the bit
is unsupported? Do those answers still apply for bits 6 and 13, where
a '1' indicates the absence of a feature?

What about leaf 0xa? Kvm's api.txt says, "Note that certain
capabilities, such as KVM_CAP_X86_DISABLE_EXITS, may expose cpuid
features (e.g. MONITOR) which are not supported by kvm in its default
configuration. If userspace enables such capabilities, it is
responsible for modifying the results of this ioctl appropriately."
However, it appears that the vPMU is enabled not by such a capability,
but by filling in leaf 0xa. How does userspace know what leaf 0xa
values are supported by both the hardware and kvm?

And as for KVM_CAP_X86_DISABLE_EXITS, in particular, how is userspace
supposed to know what the appropriate modification to
KVM_GET_SUPPORTED_CPUID is? Is this documented somewhere else?

And as for the "certain capabilities" clause above, should I assume
that any capability enabled by userspace may require modifications to
KVM_GET_SUPPORTED_CPUID?  What might those required modifications be?
Has anyone thought to document them, or better yet, provide an API to
get them?

What about the processor brand string in leaves 0x80000000-0x80000004?
Is a string of NULs really the only supported value?

And just a nit, but why does this ioctl bother returning explicitly
zeroed leaves for unsupported leaves in range?

It would really be nice if I could use this ioctl to write a
"HostSupportsGuest" function based in part on an existing guest's
CPUID information, but that doesn't seem all that feasible, without
intimate knowledge of how the host's implementation of kvm works.
