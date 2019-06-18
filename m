Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7773E4A5A7
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 17:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729513AbfFRPma (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 11:42:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46970 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729189AbfFRPm3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 11:42:29 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 03F27306E61C;
        Tue, 18 Jun 2019 15:42:24 +0000 (UTC)
Received: from work-vm (ovpn-117-76.ams2.redhat.com [10.36.117.76])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D2CF7179E3;
        Tue, 18 Jun 2019 15:42:21 +0000 (UTC)
Date:   Tue, 18 Jun 2019 16:42:19 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, mtosatti@redhat.com,
        rth@twiddle.net, ehabkost@redhat.com, kvm@vger.kernel.org,
        jmattson@google.com, maran.wilson@oracle.com,
        Nikita Leshenko <nikita.leshchenko@oracle.com>
Subject: Re: [QEMU PATCH v3 6/9] vmstate: Add support for kernel integer types
Message-ID: <20190618154218.GH2850@work-vm>
References: <20190617175658.135869-1-liran.alon@oracle.com>
 <20190617175658.135869-7-liran.alon@oracle.com>
 <20190618085539.GB2850@work-vm>
 <AB34E76F-231C-4E66-B5CB-113AFCE7A20F@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AB34E76F-231C-4E66-B5CB-113AFCE7A20F@oracle.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Tue, 18 Jun 2019 15:42:29 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Liran Alon (liran.alon@oracle.com) wrote:
> 
> 
> > On 18 Jun 2019, at 11:55, Dr. David Alan Gilbert <dgilbert@redhat.com> wrote:
> > 
> > * Liran Alon (liran.alon@oracle.com) wrote:
> >> Reviewed-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
> >> Reviewed-by: Maran Wilson <maran.wilson@oracle.com>
> >> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> >> ---
> >> include/migration/vmstate.h | 18 ++++++++++++++++++
> >> 1 file changed, 18 insertions(+)
> >> 
> >> diff --git a/include/migration/vmstate.h b/include/migration/vmstate.h
> >> index 9224370ed59a..a85424fb0483 100644
> >> --- a/include/migration/vmstate.h
> >> +++ b/include/migration/vmstate.h
> >> @@ -797,6 +797,15 @@ extern const VMStateInfo vmstate_info_qtailq;
> >> #define VMSTATE_UINT64_V(_f, _s, _v)                                  \
> >>     VMSTATE_SINGLE(_f, _s, _v, vmstate_info_uint64, uint64_t)
> > 
> > A comment here stating they're for Linux kernel types would be nice.
> 
> I didn’t want to state this because in theory these types can be used not in kernel context…
> I thought commit message is sufficient. I think comments in code should be made to clarify
> things. But to justify existence I think commit message should be used.
> But if you insist, I have no strong objection of adding such comment.

It's only a 'would be nice' - it's just I don't want people trying to
use them for other places (I'm not sure what happens if you pass a
uint8_t to VMSTATE_U8 ???

> > 
> >> +#define VMSTATE_U8_V(_f, _s, _v)                                   \
> >> +    VMSTATE_SINGLE(_f, _s, _v, vmstate_info_uint8, __u8)
> >> +#define VMSTATE_U16_V(_f, _s, _v)                                  \
> >> +    VMSTATE_SINGLE(_f, _s, _v, vmstate_info_uint16, __u16)
> >> +#define VMSTATE_U32_V(_f, _s, _v)                                  \
> >> +    VMSTATE_SINGLE(_f, _s, _v, vmstate_info_uint32, __u32)
> >> +#define VMSTATE_U64_V(_f, _s, _v)                                  \
> >> +    VMSTATE_SINGLE(_f, _s, _v, vmstate_info_uint64, __u64)
> >> +
> > 
> > Have you checked that builds OK on a non-Linux system?
> 
> Hmm that’s a good point. No. :P

Worth a check if you can find one lying around :-)

Dave

> -Liran
> 
> > 
> > Dave
> > 
> >> #define VMSTATE_BOOL(_f, _s)                                          \
> >>     VMSTATE_BOOL_V(_f, _s, 0)
> >> 
> >> @@ -818,6 +827,15 @@ extern const VMStateInfo vmstate_info_qtailq;
> >> #define VMSTATE_UINT64(_f, _s)                                        \
> >>     VMSTATE_UINT64_V(_f, _s, 0)
> >> 
> >> +#define VMSTATE_U8(_f, _s)                                         \
> >> +    VMSTATE_U8_V(_f, _s, 0)
> >> +#define VMSTATE_U16(_f, _s)                                        \
> >> +    VMSTATE_U16_V(_f, _s, 0)
> >> +#define VMSTATE_U32(_f, _s)                                        \
> >> +    VMSTATE_U32_V(_f, _s, 0)
> >> +#define VMSTATE_U64(_f, _s)                                        \
> >> +    VMSTATE_U64_V(_f, _s, 0)
> >> +
> >> #define VMSTATE_UINT8_EQUAL(_f, _s, _err_hint)                        \
> >>     VMSTATE_SINGLE_FULL(_f, _s, 0, 0,                                 \
> >>                         vmstate_info_uint8_equal, uint8_t, _err_hint)
> >> -- 
> >> 2.20.1
> >> 
> > --
> > Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
