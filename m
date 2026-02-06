Return-Path: <kvm+bounces-70467-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sLytF/Irhmm1KAQAu9opvQ
	(envelope-from <kvm+bounces-70467-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 18:59:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B83A51018FB
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 18:59:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 87B05302B395
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 17:59:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2006B426D11;
	Fri,  6 Feb 2026 17:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lLSI8Pi4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473C0296BD3
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 17:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770400739; cv=none; b=qgtBjrjOg5lSreiXwkWEoIUVnR1RRdmsCdTfTblsWX5upU+t4hcTzoYKxz4FToFXA1D6luSwPilTK7Jc2Tah+SrGVw9+gkLKzw2JA8cSLe8zmiwbetzMi9IjcoCjy7fqaCMLcWLgreoKImitXcUAAjt76SMpqa4117ivqD7rqnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770400739; c=relaxed/simple;
	bh=8d1BD4eF30+KyWgVRBOma68bMrR8sNdqhiQDUmpNgpM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IeeGEreKverWmJKbBTrFMx9pJJq2wLk8wg+VasIArjfqhTDD7me7slijT5GN2BNcW1WZaP0ZZT3o48Q4S5uB79SNKlZ5XpFONKQ9wbqN2NmlvxHwYe2/ukNDCw1BjAkWUK+EMl9G/51F6zHvCPrnWnBvkBqBF+ZHCMyGimDC2tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lLSI8Pi4; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a0a4b748a0so59308105ad.1
        for <kvm@vger.kernel.org>; Fri, 06 Feb 2026 09:58:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770400739; x=1771005539; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Njl6WISo/cIP/yX5hq9KMqO4jpKhLSD8WrbMSm0p7fU=;
        b=lLSI8Pi4MNI9wZxAain+SMlxBsUL2lidYR6rX0PGVDS7JAfKxH9zkWGcBLroIA/uDf
         WhaMZs9D0+jaGKhEATGpQBZbhZFqlwDbCtt5dR0XT7I1NCK9JSW7k/XV6babBKizFcIF
         /4BXviohFEWC/U48rOU/iuenE+HQvwlpkjzGg7bqQTMG9oM+Xx/TetB2D1XVIV02Cr2T
         oUKi4TUNHJBog+wGoyO53LBOf2HWcU/xyHSrhV5zGCuBG4zLnGN3ILb89DyI9vRvVbnd
         NH9qBbKMePPhFzRDYjw1UKdUa+UV5szLQlH4wmB0XGA9AbDyjtnAOhtjuRs26T5IXuAW
         tgKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770400739; x=1771005539;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Njl6WISo/cIP/yX5hq9KMqO4jpKhLSD8WrbMSm0p7fU=;
        b=oEJ6Nk030t+aL/b1E+/ezRbOL4fgXrJY/7lVPhwl8T+/aGKeFGMzQjyyZXDjDN63PI
         O++GzJGT1T+FaZ+7Fl/lIhwt4uknf7IL2oMl2XPQTa2isp8X9mdwtgTL/TmcTRPHA2/Q
         AXrSx46S2/IG2GJNBYyIQpLtCfpWb3DBkHGo9h+Bt/lHpSq8bHKRxe6y3OU3WPmhWnR2
         /lGYE/MdbPHpgsQirTce3NU8BOfrJjv3ggftufYUFFC5awZo/6lgIBVfrx8bZ6tu/msj
         KAYDzAsknQNNuUavZeN2gr5ZQsHD03oMq3F7eO7tH9FKbk3LlyPS+A4yUsxgApANMJNX
         N9EA==
X-Forwarded-Encrypted: i=1; AJvYcCXAHOvEd1TxVt6I9crHsDWMULIaKApXs7h2TVKVyjjRWxkhuJMd1uG1FvtgiiW0wSm1wEY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzbpIqkGDdw7hGpu+yAHMgBWepKPAcrYtDRgnL8HMIZMmTNcwGn
	/tz1ekfnl1jL8t8O8uWp+B4BrGTXOYDKzGBWxB4aolidHHMhPoTFuqQQYTxg3WprwB3k7jcX32V
	/RthjfQ==
X-Received: from plcb1.prod.google.com ([2002:a17:902:d301:b0:2a0:81d1:64f4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e947:b0:2a0:b066:3f55
 with SMTP id d9443c01a7336-2a951605e26mr31266215ad.10.1770400738628; Fri, 06
 Feb 2026 09:58:58 -0800 (PST)
Date: Fri, 6 Feb 2026 09:58:57 -0800
In-Reply-To: <k6wja36wxzcgyef255vl7rds56hfs25gvueqo7xoyhget2suz2@vvio2nz6zjo5>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260115011312.3675857-1-yosry.ahmed@linux.dev>
 <20260115011312.3675857-22-yosry.ahmed@linux.dev> <aYVEVRV-ASogp5dF@google.com>
 <k6wja36wxzcgyef255vl7rds56hfs25gvueqo7xoyhget2suz2@vvio2nz6zjo5>
Message-ID: <aYYr4R2tgwaajwjQ@google.com>
Subject: Re: [PATCH v4 21/26] KVM: SVM: Rename vmcb->virt_ext to vmcb->misc_ctl2
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[google.com:+];
	TAGGED_FROM(0.00)[bounces-70467-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: B83A51018FB
X-Rspamd-Action: no action

On Fri, Feb 06, 2026, Yosry Ahmed wrote:
> On Thu, Feb 05, 2026 at 05:31:01PM -0800, Sean Christopherson wrote:
> > On Thu, Jan 15, 2026, Yosry Ahmed wrote:
> > > @@ -244,6 +241,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
> > >  #define SVM_MISC_CTL_SEV_ENABLE		BIT(1)
> > >  #define SVM_MISC_CTL_SEV_ES_ENABLE	BIT(2)
> > >  
> > > +#define SVM_MISC_CTL2_LBR_CTL_ENABLE		BIT_ULL(0)
> > > +#define SVM_MISC_CTL2_V_VMLOAD_VMSAVE_ENABLE	BIT_ULL(1)
> > 
> > Since you're changing names anyways, What do you think about shortening things
> > a bit, and using the more standard syle of <scope>_<action>_<flag>?  E.g.
> > 
> >   #define SVM_MISC2_ENABLE_LBR_VIRTUALIZATION	BIT_ULL(0)
> >   #define SVM_MISC2_ENABLE_V_VMLOAD_VMSAVE	BIT_ULL(1)
> 
> SVM_MISC2_ENABLE_LBR_VIRTUALIZATION is actually longer,

Heh, yeah, I knew that when I hit "send", I just wasn't sure if V_LBR was a good
name.

> how about SVM_MISC2_ENABLE_V_LBR? Shorter and more consistent with
> SVM_MISC2_ENABLE_V_VMLOAD_VMSAVE.

Works for me.  I was mildly concerned that V_LBR wouldn't be intuitive, but since
you independently came up with the name too, apparently not :-)

