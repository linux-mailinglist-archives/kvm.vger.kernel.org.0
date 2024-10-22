Return-Path: <kvm+bounces-29380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 553499AA0C9
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 13:05:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 14B711F243A7
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 11:05:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00532199FAB;
	Tue, 22 Oct 2024 11:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HYlihbR0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C61219925F
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 11:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729595111; cv=none; b=T5J4AWk76ZXt3f6uka2rJtSHu/g+liReVmKh1zGqUTCNADDJekvidKV7uJ4nvjkWXEQtUS49nt/CkEVInIlrWWmWbMbK9Q9+PQlhwOWGAgKjE66JuTD0zP3nyWyP88CkEBub1wfTJrZdfTP1jMr6XXk5He6usfUDFhfwK59e8TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729595111; c=relaxed/simple;
	bh=Fk/mCQtoxbzwnQ7HscGSO6R2b1ACPtPhtvoAC3F+esU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EqJ0gl1llXv6+pQAmV7/3YKeWLk+hnjNNVZSfBXuF1gfucT8sBR351yo9xELtrdp87iarGwnwP4f5R0TaLWEIO6nbOFtuL/YoG3TRVOX/AnBN7r1tIV2and8Pl970pKJeaupLXNXI4HwHbtkXGpx+2/2aJ0r9JKLKSkiXqfoemg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HYlihbR0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729595108;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XgXOm/egpp5fSRjhAcPNhDSab7aMEhiEVg5mXUt45Zk=;
	b=HYlihbR0FYBKi09+HxIrZjR83Jx5NcXpxJKhSEoR/W/lK6KusPHlG/z5H16rXE52Tc1Ttz
	SzXRHjKKPNpZXnyZp9Kwkq6H5mDouDxMDCqTd/xSp2E3wHE0GCmpPfIyZZSjqLHxpzb4si
	yi64bLUGy33gPQl6T5G5po98BJ8waFg=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-572-1-6-f52TMw-jaPvV2hz7hg-1; Tue,
 22 Oct 2024 07:05:06 -0400
X-MC-Unique: 1-6-f52TMw-jaPvV2hz7hg-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 223351955D92;
	Tue, 22 Oct 2024 11:05:03 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.59])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6D63419560AE;
	Tue, 22 Oct 2024 11:04:53 +0000 (UTC)
Date: Tue, 22 Oct 2024 12:04:50 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, Beraldo Leal <bleal@redhat.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Yanan Wang <wangyanan55@huawei.com>, Thomas Huth <thuth@redhat.com>,
	John Snow <jsnow@redhat.com>,
	=?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>,
	qemu-arm@nongnu.org, Eduardo Habkost <eduardo@habkost.net>,
	devel@lists.libvirt.org, Cleber Rosa <crosa@redhat.com>,
	kvm@vger.kernel.org,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Alexandre Iooss <erdnaxe@crans.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Riku Voipio <riku.voipio@iki.fi>, Zhao Liu <zhao1.liu@intel.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 10/20] gitlab: make check-[dco|patch] a little more
 verbose
Message-ID: <ZxeG0rMSORBKjAVX@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20241022105614.839199-1-alex.bennee@linaro.org>
 <20241022105614.839199-11-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241022105614.839199-11-alex.bennee@linaro.org>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Tue, Oct 22, 2024 at 11:56:04AM +0100, Alex Bennée wrote:
> When git fails the rather terse backtrace only indicates it failed
> without some useful context. Add some to make the log a little more
> useful.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>  .gitlab-ci.d/check-dco.py   | 9 +++++----
>  .gitlab-ci.d/check-patch.py | 9 +++++----
>  2 files changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/.gitlab-ci.d/check-dco.py b/.gitlab-ci.d/check-dco.py
> index 632c8bcce8..d29c580d63 100755
> --- a/.gitlab-ci.d/check-dco.py
> +++ b/.gitlab-ci.d/check-dco.py
> @@ -19,10 +19,11 @@
>  reponame = os.path.basename(cwd)
>  repourl = "https://gitlab.com/%s/%s.git" % (namespace, reponame)
>  
> -subprocess.check_call(["git", "remote", "add", "check-dco", repourl])
> -subprocess.check_call(["git", "fetch", "check-dco", "master"],
> -                      stdout=subprocess.DEVNULL,
> -                      stderr=subprocess.DEVNULL)
> +print(f"adding upstream git repo @ {repourl}")
> +subprocess.run(["git", "remote", "add", "check-dco", repourl],
> +               check=True, capture_output=True)
> +subprocess.run(["git", "fetch", "check-dco", "master"],
> +               check=True, capture_output=True)

This is effectively no change - 'capture_output'  means stderr/out
are captured into a buffer which subprocess.run returns, but you're
not using the return value so the captured output is invisible.

If we want to see errors, then just remove the stderr/stdout
args from the check_call function, so they're no longer sent
to /dev/null


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


