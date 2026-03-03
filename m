Return-Path: <kvm+bounces-72564-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OKffNu0vp2mbfgAAu9opvQ
	(envelope-from <kvm+bounces-72564-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:01:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E2A51F5950
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:01:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D6B2731203B4
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 18:58:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65C9237268A;
	Tue,  3 Mar 2026 18:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XOBeDqo8";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ny0O2oFy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77607372682
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 18:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772564317; cv=none; b=os2SwucP+LR8BfaODcMbTp7/qbqcu7jjFzKOFlHDAdX05wpYvlDygc/bmL5wb3Ze7oFbaH5p+EtrUdYpHHdmZ1luTeWSAG81TNK/b9J58Rn8YR0fYNVaeui/E3ocMMwcUkA3xE+8f01enVjfx+wn6XnQpAObUVxfm/psqRTkdp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772564317; c=relaxed/simple;
	bh=4rVPHflxQZ8LSLE8Dt6EDI7MHv2d3lJGn4FEtsnNMj8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ETmxUhyWs9KZSoNbpi+sCb/2VGvIAjCoiX72jqSQyIun0UE0roaU4wM2Y4k4+hQgcmDS/xlCBWGTB+FfKfsS/D++boV2bzqh7ALpbHeE1BVxYsi9SdTSvUujxk49scr6RYjPflXEDgBC5G43s7pfXZyN1XEii42onosDdvvd07I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XOBeDqo8; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ny0O2oFy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772564315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lWCfpJa5aO8MQfEWHtHA3ZCj3eg+k9D3nWLcP9erzd4=;
	b=XOBeDqo8iB9KCAnsnM2TMWIYprUw4BUYcwPh072ETTNCvCFfcnOk61ut8fK7N7iH/2Lhos
	G2Db6qZjnaBXyQ4cu/9UNu83uRtg8/e2Otohn6ZuqFhWz1sEf+sDCo3MvCvljd7YgxMS+q
	Xq06ktRAamqbLniz5BeK8rz/mPwIXG0=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-uMkOIhk2PlaAv_9G0iuD2A-1; Tue, 03 Mar 2026 13:58:34 -0500
X-MC-Unique: uMkOIhk2PlaAv_9G0iuD2A-1
X-Mimecast-MFC-AGG-ID: uMkOIhk2PlaAv_9G0iuD2A_1772564314
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8c71500f274so610461385a.1
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 10:58:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772564314; x=1773169114; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lWCfpJa5aO8MQfEWHtHA3ZCj3eg+k9D3nWLcP9erzd4=;
        b=ny0O2oFywcoXnjeFRZF0h58/10uB9zhaFCSwgav1nmI1TK/6dkMNtj81vEe+0YGO4O
         gOq8gTKeC2OgnWZVogqeZa6EbVatnrWQBoy4tXjLh7qKOVxEyxExLRg/9gAJyjExk7wg
         7z7pw6ya2NDgNQLX82HO5BYOu4+HytUzF7XFGuwXiUTrwAOwkB2fNfjiPG3LGcrpTySO
         vDXsgUNdDWGYjW+zvEZSz2sxrcUMsEw77SnKDinNfD8PZOtkUAgEWr3+C78jiiyWEUL/
         qh9jhXzbaobs+Y5snidNJZsQcgT48y1z2qUe/fbRLHXtHKx915MiWB9VufFLAMRpcFY1
         amFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772564314; x=1773169114;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lWCfpJa5aO8MQfEWHtHA3ZCj3eg+k9D3nWLcP9erzd4=;
        b=N/IHZQYUmY7/2v5DUtWzAjiSGnYvcqLzsWWGpp4W1jPuPLHEhN/Erec/qjzZwSYj8E
         Q4kQa8KnbY8F50Pa+Wj4ND/ucdnLw1lY8bVWY1xEYTBNWQ/UpPg2ZJpGfSjBMA8kqqfl
         zBYYtYbukxaq0gA5EMxrNbjsmdAsGizKTkPEjaUzcXv/0j6M3xm2aIXIMve4tr6s+l1Q
         r6VA/vKP13g40VwhJ4jfZt1PLw1ExT/o5QQSIUvr+enk2y8j4h/ArYIATtvZh0xBHntG
         kwFYVsk6acN1ZGcWSTyHGJ0l8Y2eplJDLAoxgE5HtRyHfP8rZx5k1q06NrKbpUfDJiA0
         +sWQ==
X-Forwarded-Encrypted: i=1; AJvYcCWCwYVrqGJf3PQoHwQVqPpkbT1ReEMqz+KkV1fWElQLJSUc4Qp+8hCLRXae4V0Ig68JQPk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyg52+Qa7c9YFyXEjcGc+9tXvOUF2npZFeIX9QL0UCO7TR0aVrI
	VYkO/2xyLUffg5YmeCxiJodjjkx33SGG/GTyNbuY37uDolO80Qhu6bYGqSzxeolDyUVdh5fM4Sk
	JtrNPX4JriZl7D2QHZCNhm6A/C3aqFOzZqpmKH5Bf1hC3gajP99/Rvg==
X-Gm-Gg: ATEYQzwYS6xXMEr8xUbHCE5o7KGwZFblFwTbc0FZCFw9MxmAnHU25kNO4v9jSprnrzk
	pdwckqDscISYVVkbxRhDIbiYJJwYakzt8/qZukLQg7Kffc4qG5SAHEO1D/lc/MJy7j6XrIZQzGV
	iJ2/cnPdw9DxXMkVQJK5HoJHjhIwLb13ThC8sxXEnF/WAUdZwix4ufCf/2bqHQY5u1lKOhB8YIQ
	Jb4SPnDYBUiP5vtBKJ0OwTE46UtYPb9uWNa30vQtg3/lSwi1Y8XUbZiptGdrAf9VTnDRpwr8vEM
	K4QV6hFTTbaHryunlnSXDZlQ0S7P8hM3ia+1bdGr5VuQXtnMIMzyTOoejzLWNvyuYMB4WScUrUl
	dbFFQum0D+qBmEQ==
X-Received: by 2002:a05:620a:2988:b0:8c6:a487:6add with SMTP id af79cd13be357-8cbc8e8641fmr2059333185a.22.1772564313659;
        Tue, 03 Mar 2026 10:58:33 -0800 (PST)
X-Received: by 2002:a05:620a:2988:b0:8c6:a487:6add with SMTP id af79cd13be357-8cbc8e8641fmr2059329285a.22.1772564313126;
        Tue, 03 Mar 2026 10:58:33 -0800 (PST)
Received: from x1.local ([174.91.117.149])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cbbf6f948dsm1445739785a.30.2026.03.03.10.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 10:58:32 -0800 (PST)
Date: Tue, 3 Mar 2026 13:58:21 -0500
From: Peter Xu <peterx@redhat.com>
To: marcandre.lureau@redhat.com
Cc: qemu-devel@nongnu.org, Ben Chaney <bchaney@akamai.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	=?utf-8?Q?C=C3=A9dric?= Le Goater <clg@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Fabiano Rosas <farosas@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org, Mark Kanda <mark.kanda@oracle.com>
Subject: Re: [PATCH v3 03/15] virtio-mem: use warn_report_err_once()
Message-ID: <aacvTbkRZYcd4-XB@x1.local>
References: <20260226140001.3622334-1-marcandre.lureau@redhat.com>
 <20260226140001.3622334-4-marcandre.lureau@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260226140001.3622334-4-marcandre.lureau@redhat.com>
X-Rspamd-Queue-Id: 5E2A51F5950
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72564-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterx@redhat.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,x1.local:mid]
X-Rspamd-Action: no action

On Thu, Feb 26, 2026 at 02:59:48PM +0100, marcandre.lureau@redhat.com wrote:
> From: Marc-André Lureau <marcandre.lureau@redhat.com>
> 
> Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
> Reviewed-by: Cédric Le Goater <clg@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu


